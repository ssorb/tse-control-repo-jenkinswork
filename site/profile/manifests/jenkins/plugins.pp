class profile::jenkins::plugins {

  jenkins::plugin { 'workflow-step-api': }
  jenkins::plugin { 'workflow-api': }
  jenkins::plugin { 'promoted-builds': }
  jenkins::plugin { 'deployment-notification': }
  jenkins::plugin { 'puppet': }
  jenkins::plugin { 'ssh': }
  jenkins::plugin { 'envinject-api':version => '1.2',} 
  jenkins::plugin { 'envinject':version => '2.1.3',}   
  jenkins::plugin { 'gitlab-plugin':version => '1.4.7',} 
  jenkins::plugin { 'puppet-enterprise-pipeline':version => '1.3.1',} 

}
