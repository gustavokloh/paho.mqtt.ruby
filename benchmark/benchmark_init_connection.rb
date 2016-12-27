require 'benchmark'
require 'PahoMqttRuby'



client = PahoMqttRuby::Client.new(:host => 'localhost', :port => 1883)

Benchmark.bmbm do |x|
  x.report("initialize simple:") { PahoMqttRuby::Client.new }
  x.report("initialize half: ") do
    PahoMqttRuby::Client.new(
      :host => 'localhost',
      :port => 1883,
      :mqtt_version => '3.1.1',
      :clean_session => false,
      :client_id => "my_client1234",
      :username => 'Foo Bar',
      :password => 'barfoo',
      :ssl => true,
      :will_topic => "my_will_topic",
      :will_payload => "Bye Bye",
      :will_qos => 1,
      :will_retain => true,
      :keep_alive => 20,
      :ack_timeout => 3,
      :on_message => lambda { |packet| puts packet }
    )
  end
  
  x.report("Connect unencrypted mode:") do
    client.connect
    while client.connection_state != PahoMqttRuby::Client::MQTT_CS_CONNECTED
      sleep 0.001
    end
    client.disconnect
  end
end


