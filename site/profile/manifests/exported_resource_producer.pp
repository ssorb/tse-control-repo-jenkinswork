class profile:: exported_resource_producer {

  @@host { 'exported_resource_producer':
    ensure       => present
    comment      => 'Abir put this here'
    ip           => '192.168.0.1'
  }

}