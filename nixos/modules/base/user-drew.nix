{
  users.users.drew = {
    isNormalUser = true;
    description = "Drew Deleón-Zemke";
    extraGroups = [ "wheel" ];
    linger = true;
    openssh.authorizedKeys.keys = [
      # personal mac
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKf35qWcRXme7A6qNvFXZE77gZR77VFkitxXlwPDQAzV drew.zemke@gmail.com"
      # work mac
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC91W695pYx41GogjRXOk5L4Fnmj76Uzb3jwWBhnV49G dnzemke@ucdavis.edu"
      # ceres
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPurjFbj4NHI6ThdBS3A0ndE08+o9NuQYVtVUS6cSWjM drew.zemke@gmail.com"
    ];
  };
}
