# Shapes Outdoor 2
A Flutter remake of shapes-outdoor.

## Create .env
* MAP_URL: raster tile layer url to use in light mode
* MAP_URL_DARK: raster tile layer url to use in dark mode

```
MAP_URL=...
MAP_URL_DARK=...
```

If it is not MapTiler, the map attribution has to be updated.

## Bulid Release
### Android
1. Create android/key.properties and fill in keystore parameters
2. `flutter build appbundle` or `flutter bulid apk`