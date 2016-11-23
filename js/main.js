/* ============================== */
/*              MAIN              */
/* ============================== */

function placeRandomCloud(tagName){
   target = document.getElementsByTagName(tagName);
   pos = Math.random()*90 + "%"

   var img = new Image();
   img.src = "assets/cloudWhite_64.svg";
   img.className = "cloudling";
   img.alt = "10";
   img.style.top = pos

   target[0].appendChild(img);
   //console.log("Added cloud at: " + pos);
}

function removeCloud(className){
   target = document.getElementsByClassName(className)[0];
   target.parentNode.removeChild(target);

   //console.log("Removed Cloud.");
}

function cloudRate(tagName,className,limit){
   count = document.getElementsByClassName(className).length;
   if(count >= limit){
      removeCloud(className);
      count -= 1;
   }
   if(count < limit){
      placeRandomCloud(tagName)
   }

   //console.log("Cloud Count: " + count)
}

function placeGoldenCloud(tagName){
   target = document.getElementsByTagName(tagName);
   pos = Math.random()*75 + "%"

   var img = new Image();
   img.src = "assets/cloudGold_64.svg";
   img.className = "goldenCloud";
   img.alt = "10";
   img.style.top = pos

   target[0].appendChild(img);
   console.log("Added cloud at: " + pos);
}

function goldenCloudRate(tagName,className,limit){
   count = document.getElementsByClassName(className).length;
   if(count >= limit){
      removeCloud(className);
      count -= 1;
   }
   if(count < limit){
      placeGoldenCloud(tagName)
   }

   //console.log("Cloud Count: " + count)
}

/* ============================== */
/*             ONLOAD             */
/* ============================== */

window.onload = function(){
   setInterval("cloudRate('body','cloudling',30)",333);
   setInterval("goldenCloudRate('body','goldenCloud',1)",30000);
}
