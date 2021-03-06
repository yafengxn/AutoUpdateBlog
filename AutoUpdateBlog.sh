#!/bin/sh
# 发布环境文件夹
PublishArticleEnvDir=/Users/feng/Desktop/Code/GithubDemo/yafengxn.github.io/
PublishArticleSourcePath=/Users/feng/Documents/NoteBook/missing-semester
PublishArticleDir=$(echo $PublishArticleSourcePath | sed -e 's/\/.*\///g')
# 待发布文件名
PublishArticleName=${1}
# 待发布文件路径
PublishArticlePath=${PublishArticleSourcePath}/${PublishArticleName}

# 校验是否已存在对应md文件
verfiyArticleIfExist() {
    for file in `ls "$PublishArticleEnvDir/_posts"`; do
        result=$(echo $file | grep "${1}")
        if [ "$result" != "" ]; then
            echo "$file"
            return
        fi
    done
    echo ""
}

# 修改文件名为2020-11-04-misssemester-文件名，并拷贝到指定目录
copyArticleToPublishEnv() {
    PublishArticleName=`verfiyArticleIfExist $1`
    if [[ "$PublishArticleName" == "" ]]; then
        PublishArticleName=$(date "+%Y-%m-%d")-"$PublishArticleDir"-$PublishArticleName
    fi

	if [ ! -f "$PublishArticlePath" ]; then
		echo "❌Error: 待发布文章不存在, 请查看源文件是否存在"
		exit 0
	else
		echo "🌈Target publish article path: $PublishArticlePath"
	fi

	# 拷贝
    cp $PublishArticlePath $PublishArticleEnvDir/_posts/$PublishArticleName
	if [  $? -ne 0 ]; then
		echo "❌Error: 待发布文章不存在, 请查看是否copy成功"
		exit 0
	fi
}

# 生成静态网页资源
produceStaticHtmlResource() {
	cd $PublishArticleEnvDir || echo "❌Error: 进入发布环境失败" || exit 0
	script/cibuild
}

# 上传静态网页资源
uploadFiles() {
	git add .
	git commit -m "update new article $1"
	if git push origin main; then
		echo "🌈Hooray: 恭喜，更新博客成功!"
	fi
}

# main
main() {
	copyArticleToPublishEnv "$PublishArticleName"
    produceStaticHtmlResource
	uploadFiles "$PublishArticleName"
}

main

