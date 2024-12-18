$(function(){
    const ResourceName = 'esx_realistic_atm';
    const settings = {
        numPadAudio: './numPadBeep.flac',
        numPadAudioVolume: 0.5,
        btnAudio: './btnAudio.ogg',
        pincodePage : {
            selectedOptionTitle: "PIN kód bevitel",
            title: "Kérjük, adja meg PIN kódját!",
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            description2: "Kérjük, kezelje PIN kódját bizalmasan!",
        },
        firstPage : {
            title: 'Kérjük, válasszon tranzakciót!',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'Tranzakció választás',
            buttons: {
                pinChange : {
                    label: 'PIN-kód csere',
                    pos : "btn-3",
                    btnFunc : function() {
                        createPinChangePage();
                    }
                },
                balance : {
                    label: 'Egyenleglekérdezés',
                    pos : "btn-6",
                    btnFunc : function() {
                        createBalancePage();
                    }
                },
                withdraw : {
                    label: 'Pénzfelvétel',
                    pos : "btn-7",
                    btnFunc : function() {
                        createWithdrawPage();
                    }
                },
                deposit : {
                    label: 'Készpénzbefizetés',
                    pos : "btn-8",
                    btnFunc : function() {
                        createDepositPage();
                    }
                },
                exit : {
                    label: 'Kilépés',
                    pos : "btn-4",
                    btnFunc : function() {
                        closeATM();
                    }
                }
            }
        },
        pinChangePage : {
            title: 'PIN-kód csere',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'PIN-kód csere',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                },
            }
        },
        pinChange2Page : {
            title: 'Írd be újra az új PIN-kódot!',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'PIN-kód csere',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        pinChangePage(settings.pinChangePage);
                    }
                }
            }
        },

        failedPinPage : {
            title: 'Hibás PIN-kód!',
            description: 'A beírt PIN-kód nem egyezik meg az elsővel!',
            selectedOptionTitle: 'PIN-kód csere',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                }
            }
        },

        succesPinPage : {
            title: 'Sikeres PIN-kód csere!',
            description: 'A PIN-kódod sikeresen megváltozott!',
            selectedOptionTitle: 'PIN-kód csere',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                }
            }
        },
        withdrawPage : {
            title: 'Pénzfelvétel',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'Pénzfelvétel',
            buttons: {
                btn1: {
                    label: '1000 Ft',
                    pos : "btn-2",
                    btnFunc : function() {
                        createReceiptPage(1000);
                    }
                },
                btn2: {
                    label: '2000 Ft',
                    pos : "btn-3",
                    btnFunc : function() {
                        createReceiptPage(2000);
                    }
                },
                btn3: {
                    label: '5000 Ft',
                    pos : "btn-4",
                    btnFunc : function() {
                        createReceiptPage(5000);
                    }
                },
                btn4: {
                    label: '10000 Ft',
                    pos : "btn-6",
                    btnFunc : function() {
                        createReceiptPage(10000);
                    }
                },
                btn5: {
                    label: '20000 Ft',
                    pos : "btn-7",
                    btnFunc : function() {
                        createReceiptPage(20000);
                    }
                },
                btn6: {
                    label: 'Egyéb összeg',
                    pos : "btn-8",
                    btnFunc : function() {
                        createOtherAmountPage();
                    }
                }
            }

        },
        createOtherAmountPage : {
            title: 'Egyéb összeg',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'Pénzfelvétel',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createWithdrawPage();
                    }
                },
            }

        },

        createReceiptPage : {
            title: 'Kérjük, vegye ki a kívánt összeget!',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'Pénzfelvétel',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                },
                moreCash : {
                    label: 'További pénzfelvétel',
                    pos : "btn-8",
                    btnFunc : function() {
                        createWithdrawPage();
                    }
                }
            }

        },
        createDepositPage : {
            title: 'Készpénz befizetés',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'Készpénz befizetés',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                },
                btn1: {
                    label: '1000 Ft',
                    pos : "btn-2",
                    btnFunc : function() {
                        createDepositPageInfo(1000);
                    }
                },
                btn2: {
                    label: '2000 Ft',
                    pos : "btn-3",
                    btnFunc : function() {
                        createDepositPageInfo(2000);
                    }
                },
                btn3: {
                    label: '5000 Ft',
                    pos : "btn-4",
                    btnFunc : function() {
                        createDepositPageInfo(5000);
                    }
                },
                btn4: {
                    label: '10000 Ft',
                    pos : "btn-6",
                    btnFunc : function() {
                        createDepositPageInfo(10000);
                    }
                },
                btn5: {
                    label: '20000 Ft',
                    pos : "btn-7",
                    btnFunc : function() {
                        createDepositPageInfo(20000);
                    }
                },
                btn6: {
                    label: 'Egyéb összeg',
                    pos : "btn-8",
                    btnFunc : function() {
                        createOtherAmountPageDeposit();
                    }
                }
            }

        },
        createOtherAmountPageDeposit : {
            title: 'Egyéb összeg',
            description: 'Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'Készpénz befizetés',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createDepositPage();
                    }
                },
            }

        },
        createDepositPageInfo : {
            title: 'Kérjük, helyezze a bankjegyeket a nyílásba!',
            description: 'Távolítson el minden egyéb idegen tárgyat a bankjegyek közül (aprópénz, kapcsok, papír, stb ... )!<br>Erősen gyűrött bankjegyet ne tegyen az ATM-be!<br>max. 200 db<br>Egy tranzakcióban maximum 4.000.000 Ft illetve 200 db bankjegy befizetése lehetséges!<br>Megszakítás lent, a TÖRLÉS [] gombbal!',
            selectedOptionTitle: 'Készpénz befizetés'
        },

        createBalancePage : {
            title: 'Egyenleglekérdezés',
            description: 'Az ön egyenlege:',
            selectedOptionTitle: 'Egyenleglekérdezés',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                },
            }

        },

        createAcceptDepositPage : {
            title: 'Teljes behelyezett összeg:',
            description: '-',
            selectedOptionTitle: 'Készpénz befizetés',
            buttons: {
                approve : {
                    label: 'Jóváhagy',
                    pos : "btn-7",
                    btnFunc : function() {
                        acceptDeposit();
                    }
                },
                exit : {
                    label: 'Kilépés',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                },
                moreDeposit : {
                    label: 'További befizetés',
                    pos : "btn-8",
                    btnFunc : function() {
                        createDepositPage();
                    }
                }
            }
        },
        failedWithdrawPage : {
            title: 'Sikertelen pénzfelvétel!',
            description: 'Az ATM nem tudja kiszolgálni a kérését!',
            selectedOptionTitle: 'Pénzfelvétel',
            buttons: {
                exit : {
                    label: 'Vissza',
                    pos : "btn-4",
                    btnFunc : function() {
                        createFirstPage();
                    }
                }
            }
        },

        acceptDepositPage : {
            title: 'Készpénz befizetés',
            description: 'Vegye ki a bankjegyeket a nyílásból!',
            selectedOptionTitle: 'Készpénz befizetés',
        }

    };

    var PINCODE = null;
    var CAN_DEPOSIT = false;
    var CURRENT_INPUT_VALUE = null;
    var ACTUAL_ATM_MODEL = null;
    const PinAudio = new Audio(settings.numPadAudio);
    PinAudio.volume = settings.numPadAudioVolume;
    const BtnAudio = new Audio(settings.btnAudio);
    BtnAudio.volume = settings.numPadAudioVolume;

    var BANK_MONEY = 0;
    var MONEY = 0;



    let handlers = {
        "btn-1": null,
        "btn-2": null,
        "btn-3": null,
        "btn-4": null,
        "btn-5": null,
        "btn-6": null,
        "btn-7": null,
        "btn-8": null,
        "num-1": null,
        "num-2": null,
        "num-3": null,
        "CANCEL": null,
        "num-4": null,
        "num-5": null,
        "num-6": null,
        "CLEAR": null,
        "num-7": null,
        "num-8": null,
        "num-9": null,
        "ENTER": null,
        "EMPTY-1": null,
        "num-0": null,
        "EMPTY-2": null,
        "EMPTY-3": null
    };

    function addHandler(actionKey, handler) {
        handlers[actionKey] = handler;
    }

    function handleBtnClick(actionKey) {
        if (handlers[actionKey]) {
            handlers[actionKey]();
            if (actionKey.includes('num')) {
                PinAudio.play();
            }
            if (actionKey.includes('btn')) {
                BtnAudio.play();
            }   
        }

    }

    function breakdownAmount(amount) {
        const denominations = [20000, 10000, 5000, 2000, 1000, 500];
        let breakdown = {};
        let remainingAmount = amount;
    
        for (let denom of denominations) {
            if (remainingAmount >= denom) {
                breakdown[denom] = Math.floor(remainingAmount / denom);
                remainingAmount = remainingAmount % denom;
            }
        }
    
        return breakdown;
    }
    
    function formatBreakdown(breakdown) {
        let description = '';
        let total = 0;
    
        for (let denom in breakdown) {
            let count = breakdown[denom];
            description += `${denom} HUF x ${count}<br>`;
            total += denom * count;
        }
    
        description += `Összesen = ${total} Ft<br>A bankjegyek visszavételéhez és a folyamat megszakításához kérjük, nyomja meg lent a TÖRLÉS [] gombot!`;
    
        return { description, total };
    }



    function createBtn(btnpos, btnName, btnFunc) {
        var btn = $('<div>').addClass('panel-btn').html(btnName);
        addHandler(btnpos, btnFunc);
        btn.addClass(btnpos);
        if (ACTUAL_ATM_MODEL === 'prop_atm_02' || ACTUAL_ATM_MODEL === 'prop_atm_03') {
            switch (btnpos) {
                case 'btn-1': 
                    btn.css('top', '40px');
                    btn.css('left', '0');
                    break;
                case 'btn-2':
                    btn.css('top', '170px');
                    btn.css('left', '0');
                    break;
                case 'btn-3':
                    btn.css('bottom', '150px');
                    btn.css('left', '0');
                    break;
                case 'btn-4':
                    btn.css('bottom', '20px');
                    btn.css('left', '0');
                    break;
                case 'btn-5':
                    btn.css('top', '40px');
                    btn.css('right', '0');
                    break;
                case 'btn-6':
                    btn.css('top', '170px');
                    btn.css('right', '0');
                    break;
                case 'btn-7':
                    btn.css('bottom', '150px');
                    btn.css('right', '0');
                    break;
                case 'btn-8':
                    btn.css('bottom', '20px');
                    btn.css('right', '0');
                    break;
            }
        } else if (ACTUAL_ATM_MODEL === 'prop_fleeca_atm') {
            switch (btnpos) {
                case 'btn-1': 
                    btn.css('top', '40px');
                    btn.css('left', '0');
                    break;
                case 'btn-2':
                    btn.css('top', '200px');
                    btn.css('left', '0');
                    break;
                case 'btn-3':
                    btn.css('bottom', '150px');
                    btn.css('left', '0');
                    break;
                case 'btn-4':
                    btn.css('bottom', '35px');
                    btn.css('left', '0');
                    break;
                case 'btn-5':
                    btn.css('top', '40px');
                    btn.css('right', '0');
                    break;
                case 'btn-6':
                    btn.css('top', '200px');
                    btn.css('right', '0');
                    break;
                case 'btn-7':
                    btn.css('bottom', '150px');
                    btn.css('right', '0');
                    break;
                case 'btn-8':
                    btn.css('bottom', '35px');
                    btn.css('right', '0');
                    break;
            }
        } else if (ACTUAL_ATM_MODEL === 'prop_atm_01') {

            switch (btnpos) {
            }
        }
     
        return btn;
    }


    function closeATM() {
        fetch(`https://${ResourceName}/closeATM`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({})
        }).then(resp => resp.json()).then(resp => {
            console.log(resp);
        });
    }

    function createPincodePage() {
        const pageSettings = settings.pincodePage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        const description2 = $('<p class="description2">');
        const input = $('<input class="inputField" type="password" class="input">');
        input.attr('maxlength', '4');
        input.attr('size', '4');

        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(pageSettings.description);
        description2.text(pageSettings.description2);
        createNumPad(()=> {
            input.val('');
            PINCODE = null;
            closeATM();
        }, (value) => {
           fetch(`https://${ResourceName}/handlers`, {
               method: 'POST',
               headers: {
                   'Content-Type': 'application/json; charset=UTF-8'
               },
               body: JSON.stringify({ nType: "checkPin", pin: value })
           }).then(resp => resp.json()).then(resp => {
                console.log(resp.isAccepted);
              if (resp.isAccepted) {
                    createFirstPage();
                    PINCODE = value;
              } else {
                  createPincodePage();
                }
           });
        }, () => {
            input.val('');
            PINCODE = null;
        });

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description)
            .append(description2)
            .append(input);

    }

    function createFirstPage() {
        const pageSettings = settings.firstPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(pageSettings.description);

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);
    }

    function handleNumpadInput(value, cb) {
        const inputElement = $(".inputField");
        if (!isNaN(value)) {
            const maxLength = parseInt(inputElement.attr('maxlength'));
            if ( maxLength && (inputElement.val().length >= maxLength)) {
                return;
            }
            inputElement.val(inputElement.val() + value);
            /*if (inputElement.val() < parseInt(inputElement.attr('min'))) {
                inputElement.val(inputElement.attr('min'));
            }
            if (inputElement.val() > parseInt(inputElement.attr('max'))) {
                inputElement.val(inputElement.attr('max'));
            }*/
        } else {
            if (value === 'cancel') {
               if (cb) {
                     cb();
               }
            }
            if (value === 'clear') {
                inputElement.val('');
                if (cb) {
                    cb();
                }
            }
            if (value === 'enter') {
                if (cb) {
                    cb(inputElement.val());
                }
            }

        }
    }

    function createNumPad(cancelCb, enterCb, clearCb) {
        CURRENT_INPUT_VALUE = null;
        addHandler("num-1", () => { handleNumpadInput(1); });
        addHandler("num-2", () => { handleNumpadInput(2); });
        addHandler("num-3", () => { handleNumpadInput(3); });
        addHandler("CANCEL", () => { handleNumpadInput("cancel", cancelCb); });
        addHandler("num-4", () => { handleNumpadInput(4); });
        addHandler("num-5", () => { handleNumpadInput(5); });
        addHandler("num-6", () => { handleNumpadInput(6); });
        addHandler("CLEAR", () => { handleNumpadInput("clear", clearCb); });
        addHandler("num-7", () => { handleNumpadInput(7); });
        addHandler("num-8", () => { handleNumpadInput(8); });
        addHandler("num-9", () => { handleNumpadInput(9); });
        addHandler("ENTER", () => { handleNumpadInput("enter", enterCb); });
        addHandler("EMPTY", () => { console.log('-'); });
        addHandler("num-0", () => { handleNumpadInput(0); });
        addHandler("EMPTY", () => { console.log('-'); });
        addHandler("EMPTY", () => { console.log('-'); });
    }

    function createPinChangePage() {
        const pageSettings = settings.pinChangePage; 
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        const input = $('<input class="inputField" type="password" class="input">');
        input.attr('maxlength', '4');
        input.attr('size', '4');

        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(pageSettings.description);
        createNumPad(()=> {
            input.val('');
            PINCODE = null;
            createFirstPage();
        }, (value) => {
            createPinChange2Page(value);
            PINCODE = value;
        }, () => {
            input.val('');
            PINCODE = null;
        });

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }
        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description)
            .append(input);
    }

    function createPinChange2Page(pin) {
        const pageSettings = settings.pinChange2Page;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        const input = $('<input class="inputField" type="password" class="input">');
        input.attr('maxlength', '4');
        input.attr('size', '4');

        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(pageSettings.description);
        createNumPad(()=> {
            input.val('');
            PINCODE = null;
            createFirstPage();
        }, (value) => {
            if (value === pin) {
                $.post(`https://${ResourceName}/handlers`, JSON.stringify({ nType: 'changePin', newPin: parseInt(value) }), function(isSuccess) {
                    console.log(isSuccess);
                    if (isSuccess) {
                        succesPinPage(value);
                    } else {
                        failedPinPage();
                    }
                });
            } else {
                failedPinPage();
            }
        }, () => {
            input.val('');
        });

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description)
            .append(input);
    }

    function failedPinPage() {
        const pageSettings = settings.failedPinPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(pageSettings.description);

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description
        );
    }

    function succesPinPage(newPin) {
        const pageSettings = settings.succesPinPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(pageSettings.description);

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);
    }

    function createWithdrawPage() {
        const pageSettings = settings.withdrawPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text('Pénzfelvétel');
        title.text('Kérjük, válasszon összeget!');
        description.text('Megszakítás lent, a TÖRLÉS [] gombbal!');

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);

    }

    function createOtherAmountPage() {
        const pageSettings = settings.createOtherAmountPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text('Pénzfelvétel');
        title.text('Kérjük, írja be a kívánt összeget!');
        const input = $('<input class="inputField" type="number" class="input">');
        description.text('Megszakítás lent, a TÖRLÉS [] gombbal!');

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        createNumPad(()=> { 
            CURRENT_INPUT_VALUE = null;
            createWithdrawPage();
        }, (value) => {
            CURRENT_INPUT_VALUE = value;
            createReceiptPage(value);
        }, () => {
            CURRENT_INPUT_VALUE = null;
        });



        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description)
            .append(input);
    }

    function failedWithdrawPage() {
        const pageSettings = settings.failedWithdrawPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(pageSettings.description);

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);
    }

    function createReceiptPage(amount) {
        if (amount > 4000000) {
            amount = 4000000;
        }
        if (amount < 1) {
            amount = 1;
        }
        if (amount > BANK_MONEY) {
            amount = BANK_MONEY;
        }
        const { total } = formatBreakdown(breakdownAmount(amount));
        if (total > 0) {
            fetch(`https://${ResourceName}/handlers`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({ nType: 'withdraw', amount: total })
            }).then(resp => resp.json()).then(resp => {
                console.log(resp);
                if (resp.isAccepted) {
                    const pageSettings = settings.createReceiptPage;
                    handlers = {};
                    $('#page').empty();
                    const selectedOptionTitle = $('<div class="selectedOptionTitle">');
                    const title = $('<div class="title">');
                    const description = $('<p class="description">');
                    selectedOptionTitle.text(pageSettings.selectedOptionTitle);
                    title.text(pageSettings.title);
                    let breakdown = breakdownAmount(amount);
                    const { description: descriptionText } = formatBreakdown(breakdown);
                    description.html(descriptionText);

                    for (const key in pageSettings.buttons) {
                        const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
                        $('#page').append(btn);
                    }

                    $('#page').append(selectedOptionTitle)
                        .append(title)
                        .append(description);
                } else {
                    createFirstPage();
                }
            });
        } else {
            failedWithdrawPage();
        }
    }

    function createDepositPage() {
        const pageSettings = settings.createDepositPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text('Készpénz befizetés');
        title.text('Kérjük, válassza ki a befizetni kívánt összeget!');
        description.text('Megszakítás lent, a TÖRLÉS [] gombbal!');
        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);
    }

    function createDepositPageInfo(amount) {
        const pageSettings = settings.createDepositPageInfo;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.html(pageSettings.description);

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);

        setTimeout(() => {
            createAcceptDepositPage(amount);
        }, 5000);
    }

    function createOtherAmountPageDeposit() {
        const pageSettings = settings.createOtherAmountPageDeposit;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text('Készpénz befizetés');
        title.text('Kérjük, írja be a kívánt összeget!');
        const input = $('<input class="inputField" type="number" class="input">');
        description.text('Megszakítás lent, a TÖRLÉS [] gombbal!');
        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        createNumPad(()=> {
            CURRENT_INPUT_VALUE = null;
            createDepositPage();
        }, (value) => {
            CURRENT_INPUT_VALUE = value;
            createDepositPageInfo(value);
        }, () => {
            CURRENT_INPUT_VALUE = null;
        });

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description)
            .append(input);
    }

    var CURRENT_DEPOSIT_AMOUNT = 0;
    function createAcceptDepositPage(amount) {
        if (amount > 4000000) {
            amount = 4000000;
        }
        if (amount < 1) {
            amount = 1;
        }
        if (amount > MONEY) {
            amount = MONEY;
        }
        const pageSettings = settings.createAcceptDepositPage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text('Készpénz befizetés');
        title.text('Teljes behelyezett összeg:');
        let breakdown = breakdownAmount(amount);
        const { description: descriptionText, total } = formatBreakdown(breakdown);
        description.html(descriptionText);
        CURRENT_DEPOSIT_AMOUNT = total;
        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);
    }

    function createBalancePage() {
        const pageSettings = settings.createBalancePage;
        handlers = {};
        $('#page').empty();
        const selectedOptionTitle = $('<div class="selectedOptionTitle">');
        const title = $('<div class="title">');
        const description = $('<p class="description">');
        selectedOptionTitle.text(pageSettings.selectedOptionTitle);
        title.text(pageSettings.title);
        description.text(`${pageSettings.description} ${BANK_MONEY} Ft`);

        for (const key in pageSettings.buttons) {
            const btn = createBtn(pageSettings.buttons[key].pos, pageSettings.buttons[key].label, pageSettings.buttons[key].btnFunc);
            $('#page').append(btn);
        }

        $('#page').append(selectedOptionTitle)
            .append(title)
            .append(description);
    }

    function acceptDeposit() {
        const pageSettings = settings.createBalancePage;
        handlers = {};
        $('#page').empty();
        fetch(`https://${ResourceName}/handlers`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ nType: 'deposit', amount: CURRENT_DEPOSIT_AMOUNT })
        }).then(resp => resp.json()).then(resp => {
            console.log(resp);
            if (resp.isAccepted) {
                const selectedOptionTitle = $('<div class="selectedOptionTitle">');
                const title = $('<div class="title">');
                const description = $('<p class="description">');
                selectedOptionTitle.text(pageSettings.selectedOptionTitle);
                title.text(pageSettings.title);
                description.text(pageSettings.description);
                $('#page').append(selectedOptionTitle)
                    .append(title)
                    .append(description);
                setTimeout(() => {
                    createFirstPage();
                }, 5000);
            } else {
                createFirstPage();
            }
        });
    }


    // createFirstPage();
    // createWithdrawPage();
    // createOtherAmountPage();
    // createReceiptPage();
    // createDepositPageInfo();
    // createAcceptDepositPage();

    window.addEventListener('message', function (event) {
        console.log("itt lenni")
        console.log(JSON.stringify(event.data));
        const data = event.data;
        if (data.type === "getDuiState") {
            fetch(`https://${ResourceName}/duiIsReady`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({ ok: true })
            });
        } else if(data.type === 'openATM') {
            if (data.show) {
                $('body').show();
                ACTUAL_ATM_MODEL = data.modelName;
                if (data.modelName === 'prop_fleeca_atm') {
                    $('body').css({
                        'width': '1533px',
                        'height': '1117px',
                        'background-image': 'url("./atm2.webp")',
                        'background-repeat': 'no-repeat',
                    });
                    $('.atm-panel').css({
                        bottom: '40px',
                        left: '15px'
                    })
                    console.log('Body width:', $('body').css('width'));
                    console.log('Body height:', $('body').css('height'));
                } else {
                    $('body').css({
                        'width': '742px',
                        'height': '512px',
                        'background-image': 'none',
                    });
                    $('.atm-panel').css({
                        bottom: '0',
                        left: '0'
                    })
                }

                if (data.waterMarkLink) {
                    $('.watermark').attr('src', data.waterMarkLink);
                } else {
                    $('.watermark').hide();
                }

                if (data.colorHash) {
                    $('.atm-panel').css('background-color', data.colorHash);
                }

                CAN_DEPOSIT = data.canDeposit;
                if (data.disablePincode) {
                    return createFirstPage();
                } 
                createPincodePage();
            } else {
                $('body').hide();
                handlers = {};
                CURRENT_INPUT_VALUE = null;
                PINCODE = null;
            }
        } else if (data.type === 'buttonClick') {
            handleBtnClick(data.action);
        } else if (data.type === 'updateData') {
            const money = data.money;
            const bankMoney = data.bankMoney;
            BANK_MONEY = bankMoney;
            MONEY = money;
        }
    });

   
})