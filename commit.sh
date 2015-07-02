git commit -am"."
git push origin gh-pages
CWD=`pwd`
cp -R _site/* ../dakinegroup.github.io/
cd ../dakinegroup.github.io
git commit -am"."
git push origin master
cd -
