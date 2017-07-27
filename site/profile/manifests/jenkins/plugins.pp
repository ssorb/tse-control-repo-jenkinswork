class profile::jenkins::plugins {
  jenkins::plugin { 'ace-editor': }
  jenkins::plugin { 'ant':version}
  jenkins::plugin { 'antisamy-markup-formatter'}
  jenkins::plugin { 'authentication-tokens':}
  jenkins::plugin { 'bouncycastle-api':}
  jenkins::plugin { 'branch-api':}
  jenkins::plugin { 'build-timeout':}
  jenkins::plugin { 'cloudbees-folder':}
  jenkins::plugin { 'credentials-binding':}
  jenkins::plugin { 'display-url-api':}
  jenkins::plugin { 'docker-commons':}
  jenkins::plugin { 'docker-workflow':}
  jenkins::plugin { 'durable-task':}
  jenkins::plugin { 'email-ext':}
  jenkins::plugin { 'envinject':}
  jenkins::plugin { 'envinject-api':}
  jenkins::plugin { 'external-monitor-job':}
  jenkins::plugin { 'git':}
  jenkins::plugin { 'git-client':}
  jenkins::plugin { 'git-server':}
  jenkins::plugin { 'github':}
  jenkins::plugin { 'github-api':}
  jenkins::plugin { 'github-branch-source':}
  jenkins::plugin { 'gitlab-plugin':}
  jenkins::plugin { 'gradle':}
  jenkins::plugin { 'handlebars':}
  jenkins::plugin { 'hipchat':}
  jenkins::plugin { 'icon-shim':}
  jenkins::plugin { 'jackson2-api':}
  jenkins::plugin { 'jquery-detached':}
  jenkins::plugin { 'junit':}
  jenkins::plugin { 'ldap':}
  jenkins::plugin { 'mailer':}
  jenkins::plugin { 'mapdb-api':}
  jenkins::plugin { 'matrix-auth':}
  jenkins::plugin { 'matrix-project'}
  jenkins::plugin { 'momentjs':}
  jenkins::plugin { 'pam-auth':}
  jenkins::plugin { 'php-builtin-web-server':}
  jenkins::plugin { 'pipeline-build-step':}
  jenkins::plugin { 'pipeline-github-lib':}
  jenkins::plugin { 'pipeline-graph-analysis':}
  jenkins::plugin { 'pipeline-input-step':}
  jenkins::plugin { 'pipeline-milestone-step':}
  jenkins::plugin { 'pipeline-model-api':}
  jenkins::plugin { 'pipeline-model-declarative-agent':}
  jenkins::plugin { 'pipeline-model-definition':}
  jenkins::plugin { 'pipeline-model-extensions':}
  jenkins::plugin { 'pipeline-rest-api':}
  jenkins::plugin { 'pipeline-stage-step':}
  jenkins::plugin { 'pipeline-stage-tags-metadata':}
  jenkins::plugin { 'pipeline-stage-view':}
  jenkins::plugin { 'plain-credentials':}
  jenkins::plugin { 'puppet-enterprise-pipeline':}
  jenkins::plugin { 'resource-disposer':}
  jenkins::plugin { 'scm-api':}
  jenkins::plugin { 'script-security':}
  jenkins::plugin { 'ssh-credentials':}
  jenkins::plugin { 'ssh-slaves':}
  jenkins::plugin { 'subversion':}
  jenkins::plugin { 'timestamper':}
  jenkins::plugin { 'token-macro':}
  jenkins::plugin { 'windows-slaves':}
  jenkins::plugin { 'workflow-aggregator':}
  jenkins::plugin { 'workflow-api':}
  jenkins::plugin { 'workflow-basic-steps':}
  jenkins::plugin { 'workflow-cps':}
  jenkins::plugin { 'workflow-cps-global-lib':}
  jenkins::plugin { 'workflow-durable-task-step':}
  jenkins::plugin { 'workflow-job':}
  jenkins::plugin { 'workflow-multibranch':}
  jenkins::plugin { 'workflow-scm-step':}
  jenkins::plugin { 'workflow-step-api':}
  jenkins::plugin { 'workflow-support':}
  jenkins::plugin { 'ws-cleanup':}
}