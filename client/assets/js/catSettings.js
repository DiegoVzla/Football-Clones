
var colors = Object.values(allColors())

var defaultDNA = {
    "headcolor" : 10,
    "mouthColor" : 13,
    "eyesColor" : 96,
    "earsColor" : 10,
    //Cattributes
    // "eyesShape" : 1,
    // "decorationPattern" : 1,
    // "decorationMidcolor" : 13,
    // "decorationSidescolor" : 13,
    // "animation" :  1,
    // "lastNum" :  1
    }

// when page load
$( document ).ready(function() {
  $('#dnajersey').html(defaultDNA.jerseyColor);
  $('#dnahair').html(defaultDNA.hairColor);
  $('#dnasocks').html(defaultDNA.socksColor);
  $('#dnashoes').html(defaultDNA.shoesColor);
    
//   $('#dnashape').html(defaultDNA.eyesShape)
//   $('#dnadecoration').html(defaultDNA.decorationPattern)
//   $('#dnadecorationMid').html(defaultDNA.decorationMidcolor)
//   $('#dnadecorationSides').html(defaultDNA.decorationSidescolor)
//   $('#dnaanimation').html(defaultDNA.animation)
//   $('#dnaspecial').html(defaultDNA.lastNum)

  renderPlayer(defaultDNA)
});

function getDna(){
    var dna = ''
    dna += $('#dnajersey').html()
    dna += $('#dnahair').html()
    dna += $('#dnasocks').html()
    dna += $('#dnashoes').html()
    // dna += $('#dnashape').html()
    // dna += $('#dnadecoration').html()
    // dna += $('#dnadecorationMid').html()
    // dna += $('#dnadecorationSides').html()
    // dna += $('#dnaanimation').html()
    // dna += $('#dnaspecial').html()

    return parseInt(dna)
}

function renderPlayer(dna){
    jerseyColor(colors[dna.bodycolor],dna.bodycolor)
    $('#bodycolor').val(dna.bodycolor)
}

// Changing cat colors
$('#bodycolor').change(()=>{
    var colorVal = $('#bodycolor').val()
    jerseyColor(colors[colorVal],colorVal)
})

$('#haircolor').change(()=>{
  var hcolorVal = $('#haircolor').val()
  hairColor(colors[hcolorVal],hcolorVal)
})
$('#sockscolor').change(()=>{
  var scolorVal = $('#sockscolor').val()
  socksColor(colors[scolorVal],scolorVal)
})
$('#shoescolor').change(()=>{
  var shcolorVal = $('#shoescolor').val()
  shoesColor(colors[shcolorVal],shcolorVal)
})
