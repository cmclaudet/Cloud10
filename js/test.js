/* ============================== */
/*              MAIN              */
/* ============================== */

function placeRandomCloud(tagName){
   target = document.getElementsByTagName(tagName);
   pos = Math.random()*100 + "%"

   var img = new Image();
   img.src = "assets/cloudWhite_64_2.svg";
   img.className = "cloudling";
   img.alt = "10";
   img.style.top = pos

   target[0].appendChild(img);
   console.log("Added cloud at: " + pos);
}

function removeCloud(className){
   target = document.getElementsByClassName(className)[0];
   target.parentNode.removeChild(target);

   console.log("Removed Cloud.");
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
}

/* ============================== */
/*             ONLOAD             */
/* ============================== */

window.onload = function(){
   setInterval("cloudRate('header','cloudling',10)",1000);
}

/* ============================== */
/*              TEST              */
/* ============================== */

function test(){
   console.log("This is a Test!");
}
