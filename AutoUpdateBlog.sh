#!/bin/sh
DefaultTargetDir=/Users/feng/Desktop/Code/GithubDemo/yafengxn.github.io/
DefaultArticlePath=/Users/feng/Documents/NoteBook/missing-semester
PublishArticle=${DefaultArticlePath}/${1}
PublishArticleDir=$(echo $DefaultArticlePath | sed -e 's/\/.*\///g')
echo "ariticle dir: $PublishArticleDir"
echo "article path: $PublishArticle"
if [ ! -f "$PublishArticle" ]; then
	echo "待发布文章不存在"
	exit 0
fi
#修改文件名为2020-11-04-misssemester-文件名，并拷贝到指定目录
TargetPublishArticleName=$(date "+%Y-%m-%d")-"$PublishArticleDir"-$1
echo "Target publish article: $TargetPublishArticleName"
cp "$PublishArticle" "$DefaultTargetDir/_posts/$TargetPublishArticleName"
if [ $? -ne 0 ]; then
	echo "copy 文件失败，请确认文件是否存在"
	exit 0
fi

#添加文件头


cd $DefaultTargetDir
script/cibuild

# 上传到github
git add .
git commit -m "update new article $1"
git push origin main
if [ $? -eq 0 ]; then
	echo "🌈恭喜，更新博客成功!"
fi
