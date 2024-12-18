async function loadScaleform(scaleform) {
    let scaleformHandle = RequestScaleformMovie(scaleform);
  
    return new Promise(resolve => {
      const interval = setInterval(() => {
        if (HasScaleformMovieLoaded(scaleformHandle)) {
          clearInterval(interval);
          resolve(scaleformHandle);
        } else {
          scaleformHandle = RequestScaleformMovie(scaleform);
        }
      }, 0);
    });
  }
  
  const url = 'https://w.soundcloud.com/player/?url=' +
    'https%3A//api.soundcloud.com/tracks/467725488&color=%23ff5500&auto_play=true' +
    '&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true&visual=true';
  const scale = 0.1;
  const sfName = 'generic_texture_renderer';
  
  const width = 1280;
  const height = 720;
  
  let sfHandle = null;
  let txdHasBeenSet = false;
  let duiObj = null;
  
  setTick(() => {
    const ped = PlayerPedId();
    const pos = GetEntityCoords(ped);
  
    if (sfHandle !== null && !txdHasBeenSet) {
      PushScaleformMovieFunction(sfHandle, 'SET_TEXTURE');
  
      PushScaleformMovieMethodParameterString('meows'); // txd
      PushScaleformMovieMethodParameterString('woof'); // txn
  
      PushScaleformMovieFunctionParameterInt(0); // x
      PushScaleformMovieFunctionParameterInt(0); // y
      PushScaleformMovieFunctionParameterInt(width);
      PushScaleformMovieFunctionParameterInt(height);
  
      PopScaleformMovieFunctionVoid();
  
      txdHasBeenSet = true;
    }
  
    if (sfHandle !== null && HasScaleformMovieLoaded(sfHandle)) {
      DrawScaleformMovie_3dNonAdditive(
        sfHandle,
        pos[0] - 1, pos[1], pos[2] + 2,
        0, 0, 0,
        2, 2, 2,
        scale * 1, scale * (9/16), 1,
        2,
      );
    }
  });
  
  on('onClientResourceStart', async (resName) => {
    if (resName === GetCurrentResourceName()) {
      sfHandle = await loadScaleform(sfName);
  
      runtimeTxd = 'meows';
  
      const txd = CreateRuntimeTxd('meows');
      const duiObj = CreateDui(url, width, height);
      const dui = GetDuiHandle(duiObj);
      const tx = CreateRuntimeTextureFromDuiHandle(txd, 'woof', dui);
    }
  })
  
  on('onResourceStop', (resName) => {
    if (resName === GetCurrentResourceName()) {
      DestroyDui(duiObj);
      SetScaleformMovieAsNoLongerNeeded(sfName)
    }
  })