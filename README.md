# RStool
## An OpenComputers Refined Storage Manager

Monitors and maintains your Refined Storage Network!

If you're running Minecraft 1.10, you need the [OC-RS driver](https://www.curseforge.com/minecraft/mc-mods/open-computers-refined-storage-driver), oherwise it's built into Refined Storage 1.11+</br></br>

### Installing
You need OPPM installed to install the package

Steps to install
1. `oppm register kittypickles9982/RStool`
2. `oppm install RStool`
3. Done!

### Usage

Main screen shows
- Energy usage
- Items in storage/max items
- A progress bar showing percent filled
- Fluid in storage/max fluid
- A progress bar showing percent filled
- Items moved that second
- Time the program has been running

![Image Showing Program Screen](https://github.com/kittypickles9982/RStool/raw/main/screenExample.png)

In `config.cfg`, you set
- What items you want to export, if any
- Max network fluid capactity
- Max network item capacity

In stacks, you put the items you want it to export and monitor</br>
A stack is a table used by RS to define items</br>
Not all categories are required, the ones you put in are the ones, the program will search for</br>
Example Fluid: `{name="water", label="Water", amount=1000.0}`</br>
Example Item: `{name="minecraft:dirt", size=1234, label="Dirt"}`

Example config
```lua
{
  stacks = {
    {name="minecraft:leather"},
    {label="Soul Sand"}
  },
  maxItems = 1024000,
  maxFluids = 2048000000,
  output = sides.south
}
```
You can hold left control to exit the program</br></br>

### Future Plans
- [ ] Make progress bars work |----------------| Intermediate
- [ ] Add error handling |-----------------------| Intermediate
- [ ] Split main script into multiple files |------| Easy
- [ ] Make clickable GUI |-----------------------| Difficult
