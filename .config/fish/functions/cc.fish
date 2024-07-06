#!/usr/bin/env fish

function cc --wraps='copier copy' --description 'alias cc=copier copy'
    command copier copy --data "github_username=FollowTheProcess" --data "author_name=Tom Fleet" --data "author_email=tomfleet2018@gmail.com" $argv
end
