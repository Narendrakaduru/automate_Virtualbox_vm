pipeline {
    agent {
        label 'win-agent'
    }
    parameters {
        string(name: 'definition_name', description: 'VM Name')
        choice(name: 'box', choices: ['bento/ubuntu-22.04', 'bento/centos-stream-9', 'bento/debian-12.5', 'gusztavvargadr/windows-10'], description: 'VM Box')
        string(name: 'ip', description: 'VM IP Address')
        string(name: 'hostname', description: 'VM Hostname')
        string(name: 'vm_name', description: 'VM Provider Name')
        choice(name: 'memory', choices: ['1024', '2048', '4096', '6144', '8192', '10240'], description: 'VM Memory in MB')
        choice(name: 'cpu', choices: ['2', '4', '6', '8'], description: 'VM CPU Count')
        choice(name: 'vram', choices: ['16', '64', '128'], description: 'VM Video RAM in MB')
        string(name: 'network_type', defaultValue: 'public_network', description: 'Network Type')
        string(name: 'description', defaultValue: 'My virtual machine', description: 'VM Description')
    }

    environment {
        VM_NAME = "${params.definition_name}"
        BOX = "${params.box}"
        IP = "${params.ip}"
        HOSTNAME = "${params.hostname}"
        VM_NAME_PROVIDER = "${params.vm_name}"
        MEMORY = "${params.memory}"
        CPUS = "${params.cpu}"
        VRAM = "${params.vram}"
        NETWORK_TYPE = "${params.network_type}"
        DESCRIPTION = "${params.description}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    if (fileExists('automate_Virtualbox_vm')) {
                        echo "Directory 'automate_Virtualbox_vm' already exists. Removing it..."
                        bat 'rmdir /s /q automate_Virtualbox_vm'
                    }

                    echo "Cloning repository from GitHub..."
                    bat 'git clone https://github.com/Narendrakaduru/automate_Virtualbox_vm.git'
                }
            }
        }

        stage('Setup VM') {
            steps {
                script {
                    echo "Configuring Vagrant VM with the following parameters:"
                    echo "Name: ${VM_NAME}"
                    echo "Box: ${BOX}"
                    echo "IP: ${IP}"
                    echo "Hostname: ${HOSTNAME}"
                    echo "VM Name: ${VM_NAME_PROVIDER}"
                    echo "Memory: ${MEMORY} MB"
                    echo "CPUs: ${CPUS}"
                    echo "VRAM: ${VRAM} MB"
                    echo "Network Type: ${NETWORK_TYPE}"
                    echo "Description: ${DESCRIPTION}"

                    bat '''
                    cd automate_Virtualbox_vm
                    echo Running Vagrant command to set up the VM
                    vagrant up --provider=virtualbox
                    '''
                }
            }
        }
    }
}
