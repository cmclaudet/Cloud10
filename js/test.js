function test(){
   var left = generateRandom();
   confirm("asdf");
}
function showLetter() {
    var letter = imgsArray[generateRandomForArray()];
    $("div").append("<img src='GameHTML5/images/" + letter + ".png'>");
    var left = generateRandom();
    var top = generateRandom();
    $("div").last().css({"position":"absolute","top": top + "px", "left": left + "px"});
}
