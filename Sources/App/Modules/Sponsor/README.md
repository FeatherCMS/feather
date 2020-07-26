# Sponsor module

This module is reponsible for displaying a sponsorship box.

## Dependencies
 
 - System module
 
 ## Variables
 
 ```
 req.variables.set("sponsor.isEnabled", value: "true"),
 req.variables.set("sponsor.title", value: "Sponsor title"),
 req.variables.set("sponsor.description", value: "Sponsor description"),
 req.variables.set("sponsor.image.title", value: "sponsor image title"),
 req.variables.set("sponsor.image.url", value: "sponsor image link"),
 req.variables.set("sponsor.button.title", value: "click me"),
 req.variables.set("sponsor.button.url", value: "https://theswiftdev.com/about/"),
 req.variables.set("sponsor.more.title", value: "thank you"),
 req.variables.set("sponsor.more.url", value: "https://theswiftdev.com/"),
```

## Usage example

```
#if(systemVariable("sponsor.isEnabled") == "true"):
<section>
   <div class="sponsor">
       <img src="#systemVariable("sponsor.image.url")" alt="#systemVariable("sponsor.image.title")">
       <h3>#systemVariable("sponsor.title")</h3>
       <p>#systemVariable("sponsor.description")</p>
       <a class="cta" href="#systemVariable("sponsor.button.url")" target="_blank">#systemVariable("sponsor.button.title")</a>
       <a class="link" href="#systemVariable("sponsor.more.url")">#systemVariable("sponsor.more.title")</a>
   </div>
</section>
#endif
       
#extend("Sponsor/Box"):#endextend
```
