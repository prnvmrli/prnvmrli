{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();

    const splash = document.getElementById('splash-screen');
    if (splash) {
      splash.classList.add('fade-out');
      setTimeout(function() {
        if (splash.parentNode) {
          splash.parentNode.removeChild(splash);
        }
      }, 260);
    }
  }
});
