# mta-deployer

Install Postfix with just 1 line of code. 

## Getting Started

### Step 1: Install the Gem

```bash
gem install mta-deployer
```

### Step 2: Setting Up Nodes

```ruby
BlackStack::MtaDeployer::add_nodes([
  {
    # use this command to connect from terminal: ssh -i 'plank.pem' ubuntu@ec2-34-234-83-88.compute-1.amazonaws.com
    :name => 'mta01', 
    # ssh
    :net_remote_ip => '54.157.239.98',  
    :ssh_username => 'ubuntu',
    :ssh_port => 22,
    :ssh_password => '<!ssh-password!>',
    # mta domain
    :domain => 'my-domaion.xyz',
    # mta addresses
    :addresses => [
        'john.smit', # @my-domain.xyz
        'susan.sarandon', 
        'sheldon.cooker',
    ]
  }
])
```

### Step 4: Setting Up NameCheap API Credentials

[NameCheap API](https://www.namecheap.com/support/api/intro/) is requried to setup domain records like MX, SPF, DKIM, and DMARC.

```ruby
BlackStack::MtaDeployer::set({
    # NameCheap API parameters
    :namecheap_api_key => '************',
    :namecheap_user => 'LeandroSardi',
    :namecheap_username => 'LeandroSardi',
    :namecheap_client_ip => '200.114.237.5',
})
```

### Step 5: Running Deployment

## Disclaimer

The logo has been taken from [here](https://www.shareicon.net/chat-education-class-tutorial-speech-bubble-teacher-teaching-707418).