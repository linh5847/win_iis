Ansible automation for Windows IIS to create a website and binding that specific website with SSL Certificate to port 443.

We can have one ansible block of code to create many webistes with the default port 80 and suggest to keep this route. The best option to leave out the port in the code for always default to port 80 for every website we intend to create, using ansible automation.

Ansible automation for Windows IIS website binding to SSL Certificate port 433 can accepted one site only. This means that if we have two sites in need of HTTPS. Ansible will run with error and/or IIS website will turn to stop due to conflict. 

The below one block of code has been commented out and it's working fine. As soon as we uncomment out another web binding. Error will pop up and website inside IIS will stop.

<table>
<td>
```
  - name: create IISSite site
    win_iis_website:
      name: IISSite
      state: started
      ip: 127.0.0.1
      port: 80    # Suggest to remove and allows ansible to treat a default port80.
      hostname: IISSite.vntechsol.com
      application_pool: DefaultAppPool
      physical_path: C:\inetpub\wwwroot\IIS_Site
      parameters: logfile.directory:C:\inetpub\logs

  - name: create MySite site
    win_iis_website:
      name: MySite
      state: started
      ip: 192.168.56.151
      port: 80
      hostname: MySite.vntechsol.com
      application_pool: DefaultAppPool
      physical_path: C:\inetpub\wwwroot\MySite
      parameters: logfile.directory:C:\inetpub\logs

  # - name: set https binding for IISSite site
  #   win_iis_webbinding:
  #     name: IISSite
  #     protocol: https
  #     certificate_hash: "{{ cert_import.thumbprints[0] }}"
  #     port: 443
  #     ip: 127.0.0.1
  #     host_header: IISSite.vntechsol.com
  #     state: present

  - name: set https binding for MySite site
    win_iis_webbinding:
      name: MySite
      protocol: https
      certificate_hash: "{{ cert_import.thumbprints[0] }}"
      port: 443
      ip: 192.168.56.151
      host_header: MySite.vntechsol.com
      state: present
```
</td>
</table>
With the **win_iis_webbinding** module. Assume that we have not using **win_iis_website** to create a website. This **win_iis_webbinding** will get error during the execution due to no valid or website existed.

**win_iis_webbinding module**

fatal: [windows2019]: FAILED! => {
    "changed": false,
    "msg": "Unable to retrieve website with name mytest. Make sure the website name is valid and exists."
}

NOTE: The certificate in this ansible runbook is just a sample only. Need a real one that suits your corporation requirements.