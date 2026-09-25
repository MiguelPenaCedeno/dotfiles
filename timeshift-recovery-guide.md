# 🚑 Arch Linux Timeshift Recovery Guide

If a bad package update, broken kernel, or configuration error ever bricks your system, do not panic! Because you have Timeshift configured, you can perfectly revert your entire OS back in time to your last working snapshot.

Save this guide or take a picture of it on your phone so you have it when disaster strikes.

---

## Scenario A: Partial Breakage (Graphical Interface is Dead)
*Your computer turns on and boots, but bspwm crashes, X11 won't start, or you are stuck on a black terminal screen (TTY).*

1. **Log in:** At the black terminal screen, type your username (`cybernoumena`) and your password to log in.
2. **Launch Timeshift Restoration:** Run the following command:
   ```bash
   sudo timeshift --restore
   ```
3. **Select Snapshot:** Timeshift will list all your available snapshots (like the one you just made: `2026-09-25_07-16-51`). Type the **number** corresponding to the snapshot you want to restore and press `Enter`.
4. **Confirm the Restore:** Press `Enter` a few more times to skip the advanced options and confirm. Timeshift will perform a dry-run and then overwrite the broken system files with the working ones.
5. **Reboot:** When it finishes, simply run `reboot`. Your graphical interface will be back!

---

## Scenario B: Total Breakage (System refuses to boot at all)
*You get a Kernel Panic, a GRUB rescue error, or the computer freezes completely before you can even type a password.*

If the system cannot boot itself, you have to use a "Live USB".

1. **Boot from a Live USB:** Plug in any Arch Linux (or Ubuntu/Mint) installation USB and boot from it.
2. **Connect to the Internet:** If you are using an Arch USB, use `iwctl` to connect to Wi-Fi.
3. **Install Timeshift:** The Live USB needs the timeshift software to run the restore.
   ```bash
   # If using an Arch Live USB:
   pacman -Sy timeshift
   
   # If using an Ubuntu/Mint Live USB:
   sudo apt update && sudo apt install timeshift
   ```
4. **Run the Restore Tool:**
   ```bash
   sudo timeshift --restore
   ```
5. **Select Your Drive:** Timeshift will ask where your backups are stored. Select your root partition: `/dev/sda2`.
6. **Restore & Reboot:** Pick your working snapshot, confirm the restoration, and once it finishes, remove your USB and type `reboot`.

---

> 💡 **Important Note:** Timeshift uses `rsync` to back up system files (like `/usr`, `/etc`, and `/var`). It is specifically configured to **ignore** your `/home/cybernoumena` directory. This is a feature! It means when you rollback to a snapshot from 3 days ago, you will **not** lose the PDFs, scripts, or personal files you downloaded today!
