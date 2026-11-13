{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * *  drew  cd /home/drew/notes && /home/drew/notes/scripts/update.sh"
    ];
  };
}
