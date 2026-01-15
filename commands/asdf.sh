brew install asdf

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git

asdf install nodejs lts
asdf install nodejs 24.0.1

asdf install terraform 1.14.3
asdf install terraform 1.9.8

asdf install ruby 3.4.8

asdf list all terraform
asdf list all nodejs
asdf list all nodejs 22