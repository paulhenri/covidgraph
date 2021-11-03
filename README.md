# Covidgraph 


Learning project to make a SVG chart representing deaths from the covid in France.
## Why ? 
* Create an Elixir app with sub-apps and use OTP
* Handle datas from an opendata "API"
* Try to use new librairies

## Does it works ?
Kinda... datas are retrieved from the API endpoint the SVG chart is created.
Nonetheless, the chart has a negative offset that i have not been able to troubleshoot.

## Will it see any modification ?
Probably not, but who knows ?

## How can it be used ?
After compilation you can try it with :

```bash
covidgraph --from AAAAMMDD --to AAAAMMDD --out output_folder
```

You can also use the following command to get help.
```bash
covidgraph :help
```



