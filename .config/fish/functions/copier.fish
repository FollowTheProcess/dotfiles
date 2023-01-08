#!/usr/bin/env fish

function copier --wraps="copier" --description "Wraps copier with a few defaults"

    command copier --data="github_username=FollowTheProcess" --data="author_name=Tom Fleet" --data="author_email=tomfleet2018@gmail.com" $argv

end
