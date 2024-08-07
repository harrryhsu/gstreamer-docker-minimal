
# gstreamer-docker-minimal

Minimal gstreamer build on alpine, this docker file builds a gstreamer binary that can do rtspsrc to filesink.

Only the binary and headers gets copied to the finaly image under /gstbin, they are discoverable through pkg-config if you install it.

## Configuration

Additional plugin can be enabled by adding meson option

```
-Dgst-plugins-${package}:${plugin}=enabled 
```

Package and plugin names can be found on the element description in gstreamer documentation

See this example if you wanna enable rtspsrc

```
-Dgst-plugins-good:rtsp=enabled
```
