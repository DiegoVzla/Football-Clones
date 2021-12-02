//How to implement web3 in your browser to talk to your smart contract

var web3 = new Web3(Web3.givenProvider);

var instance;
var user;
var contractAddress = '0x8B95379eC3B9174437eF5b4654fd60c5F6D437a6';

$(document).ready(function(){
    window.ethereum.enable().then(function(accounts){
        instance = new web3.eth.Contract(abi, contractAddress, {from: accounts[0]});
        user = accounts[0];

        console.log(instance);
        
        instance.events.Birth().on('data', function(event){
            console.log(event);
            let owner = event.returnValues.owner;
            let newBallerId = event.returnValues.newBallerId;
            let mumId = event.returnValues.mumId;
            let dadId = event.returnValues.dadId;
            let genes = event.returnValues.genes
            $("#ballerCreation").css("display", "block");
            $("#ballerCreation").text("owner:" + owner
                        +" newBallerId:" + newBallerId
                        +" mumId:" + mumId
                        +" dadId:" + dadId
                        +" genes:" + genes)   
        })
        .on('error', console.error);


    })
})

 //How to call smart contract functions
function createBaller(){
    var dnaStr = getDna();
    instance.methods.createBallerGen0(dnaStr).send({}, function(error, txHash){
    if(error)
        console.log(err);
        else{
            console.log(txHash);
        }
    })
}
