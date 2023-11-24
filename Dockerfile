FROM ubuntu:22.04

LABEL "com.github.actions.name"="Top Issues Labeler"
LABEL "com.github.actions.description"="Labels issies with the most +1s"
LABEL "com.github.actions.icon"="arrow-up"
LABEL "com.github.actions.color"="green"

LABEL "repository"="http://github.com/ksuchitra532/issues"
LABEL "maintainer"="Adam Zolyak <adam@tinkurlab.com>"

ADD update-issues.sh /action/upate-issues.sh

RUN chmod +x /action/upate-issues.sh

ENTRYPOINT ["/action/upate-issues.sh"]