keep_branch=$1
rtc_root=$(pwd)
for d in `ls $rtc_root`
do
  ( cd $d && git branch | grep -E 'build_' | grep -v $keep_branch | xargs git branch -D )
done
