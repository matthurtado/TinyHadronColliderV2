# Tiny Hadron Collider
<img src="https://i.imgur.com/bFylFgO.gif" width="400" height="240" />

### A very small idler for the PlayDate

---

# Installation:  
1. **Unlock** `Build and Run (Simulator).ps1` file if it's locked: open properties and click unlock in the bottom of the window.  
2. If you've installed Playdate SDK to the default path (Documents folder) then just **run** `ADD_ENV_VARIABLE.cmd` to add env variables:  
    * PLAYDATE_SDK_PATH to Playdate SDK
    * Adds Playdate SDK's bin folder to PATH (if it is not already added) to create `pdc` shortcut  

    **!!!** If you've changed default path - edit 6th line in `ADD_ENV_VARIABLE.cmd`, then run it.  
    `set SDKPATH="YOUR CUSTOM SDK PATH HERE"`
    
    This should be done only once, you need to restart VSCode after this.  
3. Open PowerShell and change execution policy to RemoteSigned, so you can run closeSim.ps1 without admin rights:  
    Enter `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` into PowerShell then hit `Y`.
4. Open template folder with VSCode, **install recomended extensions** (popup will show in the lower right corner): `Lua`, `Lua Plus`. Then restart VSCode.  
5. If you want to change "build and run" key (default is Ctrl+Shift+B):  
    * **Ctrl + K, Ctrl + S**  
    * Change keybind for `Tasks: Run Build Task` (I've changed to **F5**)  
6. Your can find your `main.lua` file inside `source` folder. Press your "Run Build Task" button, you should see "Template" text in playdate simulator.  

# Gameplay:
1. **Crank** the handle to fill up the circle to increase your score
2. **Press A/B** to open/close the item menu to improve your Tiny Hadron Collider
3. **Press Start** to save or load the game, or to toggle auto-save options