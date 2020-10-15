## dconf

```sh
sudo apt install dconf-cli

dconf dump /com/gexperts/Tilix/ > dconf/com.gexperts.Tilix.dconf

dconf load /com/gexperts/Tilix/ < dconf/com.gexperts.Tilix.dconf
```