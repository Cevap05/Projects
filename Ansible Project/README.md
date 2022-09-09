Ansible Project with useful commands on navigating with Ansible!

**RUNNING AD-HOC CMNDS**

    This command will go through all of the hosts in the inventory file, use the designated SSH key we pathed to, and use the module (-m) called “ping”. Which is not like the “ICMP Ping”, but rather will actually establish a SSH connection (give you SUCCESS if connection is all good.
    (Note: There are no defaults in "ansible.cfg" local or in "/etc/ansible/ansible.cfg" to refer to the private key or inventory file. Thus we call them in the command:)

        -> ansible all --key-file ~/.ssh/”put-key-here” -i inventory -m ping

    ---

    If the defaults are put in the ansible.cfg (local or /etc/), then you can shorten the command to this:

        -> ansible all -m ping

    ---

    How to list all hosts:

        -> ansible all --list-hosts

    ---

    How to gather facts about all hosts (you can specify just one host as well if you need):

        -> ansible all -m gather_facts
        -> ansible all -m gather_facts --limit IP-HERE (If you are targeting one machine)

    ---

    