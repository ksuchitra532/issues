FROM ubuntu:22.04

LABEL "com.github.actions.name"="Top Issues Labeler"
LABEL "com.github.actions.description"="Labels issies with the most +1s"
LABEL "com.github.actions.icon"="arrow-up"
LABEL "com.github.actions.color"="green"

LABEL "repository"="http://github.com/ksuchitra532/issues"
LABEL "maintainer"="Adam Zolyak <adam@tinkurlab.com>"

RUN apt update
RUN apt install -y git
RUN apt install -y jq

ADD update-issues.sh /action/update-issues.sh

RUN chmod +x /action/update-issues.sh

ENTRYPOINT ["/action/update-issues.sh"]