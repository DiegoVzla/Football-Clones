
//Random color
function getColor() {
    var randomColor = Math.floor(Math.random() * 16777215).toString(16);
    return randomColor
}

function genColors(){
    var colors = []
    for(var i = 10; i < 99; i ++){
      var color = getColor()
      colors[i] = color
    }
    return colors
}

//This function code needs to modified so that it works with Your cat code.
function jerseyColor(color,code) {
    $('.main, .bottom').css('background', '#' + color)  //This changes the color of the jersey
    $('#jerseycode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnajersey').html(code) //This updates the body color part of the DNA that is displayed below the cat
}

function hairColor(color,code) {
    $('.hair, .hair-right, .hair::before').css('background', '#' + color)  //This changes the color of the jersey
    $('#haircode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnahair').html(code) //This updates the body color part of the DNA that is displayed below the cat
}
function socksColor(color,code) {
    $('.socks').css('background', '#' + color)  //This changes the color of the jersey
    $('#sockscode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnasocks').html(code) //This updates the body color part of the DNA that is displayed below the cat
}
function shoesColor(color,code) {
    $('.shoes').css('background', '#' + color)  //This changes the color of the jersey
    $('#shoescode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnashoes').html(code) //This updates the body color part of the DNA that is displayed below the cat
}


//###################################################
//Functions below will be used later on in the project
//###################################################
function eyeVariation(num) {

    $('#dnashape').html(num)
    switch (num) {
        case 1:
            normalEyes()
            $('#eyeName').html('Basic')
            break
    }
}

function decorationVariation(num) {
    $('#dnadecoration').html(num)
    switch (num) {
        case 1:
            $('#decorationName').html('Basic')
            normaldecoration()
            break
    }
}

async function normalEyes() {
    await $('.cat__eye').find('span').css('border', 'none')
}

async function normaldecoration() {
    //Remove all style from other decorations
    //In this way we can also use normalDecoration() to reset the decoration style
    $('.cat__head-dots').css({ "transform": "rotate(0deg)", "height": "48px", "width": "14px", "top": "1px", "border-radius": "0 0 50% 50%" })
    $('.cat__head-dots_first').css({ "transform": "rotate(0deg)", "height": "35px", "width": "14px", "top": "1px", "border-radius": "50% 0 50% 50%" })
    $('.cat__head-dots_second').css({ "transform": "rotate(0deg)", "height": "35px", "width": "14px", "top": "1px", "border-radius": "0 50% 50% 50%" })
}
