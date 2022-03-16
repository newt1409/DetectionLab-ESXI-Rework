# Purpose: Configure winlogbeat

  $confFile = @"
winlogbeat.event_logs:
  - name: Microsoft-Windows-Sysmon/Operational
    processors:
        - script:
            lang: javascript
            id: sysmon
            file: ${path.home}/module/sysmon/config/winlogbeat-sysmon.js
  - name: System
    event_id: 104
    ignore_older: 168h
#       104     some other log was cleared besides the security log (1102 in security.evtx monitors that)
  - name: Application
    event_id: 1000, 1002
    ignore_older: 168h
#       1000    application crash - indicator of possible exploit usage
#       1002    application hang - indicator of possible exploit usage  
  - name: Security
    ignore_older: 168h
#       1102    security log cleared
#       4778    RDP initated
#       4779    RDP terminated
#       4647    user initiated logoff
#       4624    account logon
#       4625    account logon fail
#       4627    group membership information - identifies account that requested to log on
#       4634    account logoff
#       4648    logon w/explicit creds 
#       4672    admin rights adjustment
#       4688    new process spawned (check %AppData%\Local\Temp)
#       4698    task created
#       4699    task deleted
#       4700    task enabled
#       4701    task disabled
#       4702    task updated
#       4720    account created
#       4768    kerberos authentication
#       4769    kerberos ticket granted
#       4728    user added to priv group
#       4732    user added to priv group
#       4738    user account changed
#       4756    user added to priv group
#       4740    account locked
#       4771    kerberos pre-authentication failed (failed logon)
#       4776    NTLM authentication
#       4798    user local group enumerated
#       4799    security-enabled local group enumerated
#       5142    network-share object added
#       5143    network-share object modified
#       5144    network-share object deleted
#       5145    network-share object (detailed file access)
#       6416    new external device added
#       7034    unexpected service crash, indicates possible process/dll injection
#       7035    SCM ordered service to launch/shutdown
#       7036    service started/stopped
#       7040    service start type changed
#       7045    service installed    ignore_older: 168h
  - name: Microsoft-Windows-TaskScheduler/Operational
    event_id: 106, 140-141, 200-201
    ignore_older: 168h
  - name: Microsoft-Windows-RemoteDesktopServices-RDPCoreTS/Operational
    event_id: 131
    ignore_older: 168h
#       131     remote IP/user/date/time
  - name: Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational
    event_id: 1149
    ignore_older: 168h
#       1149    remote IP/user/date/time
#       106     task created
#       140     task updated
#       141     task deleted
#       200     task executed
#       201     task completed
  - name: Microsoft-Windows-PowerShell/Operational
    event_id: 4103, 4104
    ignore_older: 168h
#       4103    pipeline execution info during exec/variable init/command invoc
#               can grab some deobfuscated scripts/output data
#       4104    script-block logging
  - name: Microsoft-Windows-DriverFrameworks-UserMode/Operational
    event_id: 2003, 2004, 2006, 2010, 2100, 2101, 2105, 2106
    ignore_older: 168h
#       2003
#       2004
#       2006
#       2010
#       2100
#       2101
#       2105
#       2106

#==================== Elasticsearch template setting ==========================

#setup.template.settings:
  #index.number_of_shards: 3
  #index.codec: best_compression
  #_source.enabled: false
setup.ilm.enabled: auto
#setup.ilm.rollover_alias: "winlogbeat"
#setup.ilm.policy_name: "winlogbeat"
#setup.ilm.pattern: "%{now/d}-000001"
#================================ General =====================================

# The name of the shipper that publishes the network data. It can be used to group
# all the transactions sent by a single shipper in the web interface.
#name:

# The tags of the shipper are included in their own field with each
# transaction published.
#tags: ["service-X", "web-tier"]

# Optional fields that you can specify to add additional information to the
# output.
#fields:
#  env: staging

#============================== Dashboards =====================================
# These settings control loading the sample dashboards to the Kibana index. Loading
# the dashboards is disabled by default and can be enabled either by setting the
# options here or by using the `setup` command.
setup.dashboards.enabled: false

# The URL from where to download the dashboards archive. By default this URL
# has a value which is computed based on the Beat name and version. For released
# versions, this URL points to the dashboard archive on the artifacts.elastic.co
# website.
#setup.dashboards.url:

#============================== Kibana =====================================

# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
# This requires a Kibana endpoint configuration.
#setup.kibana:

  # Kibana Host
  # Scheme and port can be left out and will be set to the default (http and 5601)
#  # In case you specify and additional path, the scheme is required: http://localhost:5601/path
#  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601
#  #host: "localhost:5601" 

  # Kibana Space ID
  # ID of the Kibana Space into which the dashboards should be loaded. By default,
  # the Default Space will be used.
#  #space.id:

#============================= Elastic Cloud ==================================

# These settings simplify using winlogbeat with the Elastic Cloud (https://cloud.elastic.co/).

# The cloud.id setting overwrites the `output.elasticsearch.hosts` and
# `setup.kibana.host` options.
# You can find the `cloud.id` in the Elastic Cloud web UI.
#cloud.id:

# The cloud.auth setting overwrites the `output.elasticsearch.username` and
# `output.elasticsearch.password` settings. The format is `<user>:<pass>`.
#cloud.auth:

#================================ Outputs =====================================

# Configure what output to use when sending the data collected by the beat.

#-------------------------- Elasticsearch output ------------------------------
#output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["192.168.56.101:9200"]
  #idle_time: "10s"
  #max_retries: 5
  #bulk_max_size: 1
  #flush_interval: 10
  #timeout: "45s"
  # Optional protocol and basic auth credentials.
  #protocol: "http" 
  #username: "elastic" 
  #password: "password" 

#----------------------------- Logstash output --------------------------------
output.logstash:
  # The Logstash hosts
  #hosts: ["192.168.56.101:5044"]

  # Optional SSL. By default is off.
  # List of root certificates for HTTPS server verifications
  #ssl.certificate_authorities: ["/etc/pki/root/ca.pem"]

  # Certificate for SSL client authentication
  #ssl.certificate: "/etc/pki/client/cert.pem" 

  # Client Certificate Key
  #ssl.key: "/etc/pki/client/cert.key" 

#================================ Processors =====================================

# Configure processors to enhance or manipulate events generated by the beat.

processors:
- add_host_metadata:
   netinfo.enabled: true
   cache.ttl: 5m
- drop_fields:
   fields: ["winlog.event_data.CallTrace"]
# Droping the Call Trace Field to save space

#================================ Logging =====================================

# Sets log level. The default log level is info.
# Available log levels are: error, warning, info, debug
#logging.level: debug

# At debug level, you can selectively enable logging only for some components.
# To enable all selectors use ["*"]. Examples of other selectors are "beat",
# "publish", "service".
#logging.selectors: ["*"]

#============================== Xpack Monitoring ===============================
# winlogbeat can export internal metrics to a central Elasticsearch monitoring
# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The
# reporting is disabled by default.

# Set to true to enable the monitoring reporter.
#xpack.monitoring.enabled: false

# Uncomment to send the metrics to Elasticsearch. Most settings from the
# Elasticsearch output are accepted here as well. Any setting that is not set is
# automatically inherited from the Elasticsearch output configuration, so if you
# have the Elasticsearch output configured, you can simply uncomment the
# following line.
#xpack.monitoring.elasticsearch:

#================================= Migration ==================================

# This allows to enable 6.7 migration aliases
#migration.6_to_7.enabled: true
"@


$service = Get-WmiObject -Class Win32_Service -Filter "Name='winlogbeat'"
If (-not ($service)) {
  choco install winlogbeat -y

  $confFile | Out-File -FilePath C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml -Encoding ascii -Force

  sc.exe failure winlogbeat reset= 30 actions= restart/5000
  Start-Service winlogbeat
}
else {
  Write-Host "winlogbeat is already installed. Updating config file."

  Stop-Service winlogbeat
  
  $confFile | Out-File -FilePath C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml -Encoding ascii  


  Start-Service winlogbeat

}
If ((Get-Service -name winlogbeat).Status -ne "Running") {
  throw "winlogbeat service was not running"
}
