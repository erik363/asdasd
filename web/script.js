class Storage {
    constructor(id, col, row, name) {
        this.name = name;
        this.id = id;
        this.col = col;
        this.row = row;
        this.windowElement = $(`<div class="Storage window" id="${this.id}-window">
            <div class="header">
                <div class="title">${this.name}</div>
                <div class="close">X</div>
               
            </div>
            
        </div>`);
        this.storage = Array.from({ length: col }, () => Array(row).fill(0));
        this.storageElement = $(`<div class="storage" id="${this.id}"></div>`);
    }

    genHtml(appendElement) {
        for (let i = 0; i < this.col; i++) {
            let rowElement = $('<div class="row"></div>');
            for (let j = 0; j < this.row; j++) {
                let slotElement = $(`<div class="slot" data-col="${i}" data-row="${j}"></div>`);
                rowElement.append(slotElement);
            }
            this.storageElement.append(rowElement);
        }
        
        this.windowElement.append(this.storageElement);
        appendElement.append(this.windowElement);
        $(`#${this.id} .slot`).droppable({
            hoverClass: "drop-hover",
            over: (event, ui) => {
                const toSlot = $(event.target);
                const toCol = toSlot.data('col');
                const toRow = toSlot.data('row');

                if (this.storage[toCol][toRow] === 0 || (this.storage[toCol][toRow].stackable && this.storage[toCol][toRow].name === ui.helper.text().split(' x')[0])) {
                    toSlot.addClass('valid-drop').removeClass('invalid-drop');
                } else {
                    toSlot.addClass('invalid-drop').removeClass('valid-drop');
                }
            },
            out: (event, ui) => {
                $(event.target).removeClass('valid-drop invalid-drop');
            },
            drop: (event, ui) => {
                const itemElement = ui.helper;
                const fromSlot = itemElement.parent();
                const toSlot = $(event.target);

                const fromCol = fromSlot.data('col');
                const fromRow = fromSlot.data('row');
                const toCol = toSlot.data('col');
                const toRow = toSlot.data('row');

                const fromStorage = fromSlot.closest('.storage').data('storage');
                const toStorage = toSlot.closest('.storage').data('storage');

                const fromItem = fromStorage.storage[fromCol][fromRow];
                const toItem = toStorage.storage[toCol][toRow];

                if (toItem === 0) {
                    toStorage.storage[toCol][toRow] = fromItem;
                    fromStorage.storage[fromCol][fromRow] = 0;

                    toSlot.append(itemElement);
                    itemElement.css({ top: 0, left: 0 });
                } else if (toItem.stackable && toItem.name === fromItem.name) {
                    const total = fromItem.count + toItem.count;
                    if (total <= toItem.max) {
                        toItem.count = total;
                        fromStorage.storage[fromCol][fromRow] = 0;
                        fromSlot.empty();
                    } else {
                        toItem.count = toItem.max;
                        fromItem.count = total - to
                Item.max;
                    }
                    toSlot.find('.item').text(`${toItem.name} x${toItem.count}`);
                }

                toSlot.removeClass('valid-drop invalid-drop');
            }
        });
    }

    addItem(item, col, row) {
        if (this.storage[col][row] === 0) {
            this.storage[col][row] = item;
            let itemElement = $(`<div class="item">${item.name} x${item.count}</div>`);
            const e = $(`#${this.id} .slot[data-col="${col}"][data-row="${row}"]`).append(itemElement);
            itemElement.draggable({
                revert: true,
                revertDuration: 0,
                appendTo: 'body',
                zIndex: 1000,
            });

        }
    }

    removeItem(col, row) {
        if (this.storage[col][row] !== 0) {
            this.storage[col][row] = 0;
            $(`#${this.id} .slot[data-col="${col}"][data-row="${row}"]`).empty();
        }
    }
}


$(document).ready(function() {
    const storage = new Storage('inventory1', 5, 10, "Alma");
    storage.genHtml($(".MyInventory"));
    storage.addItem({
        name: 'item1',
        count: 2,
        stackable: true,
        max: 10
    }, 0, 0);
    storage.addItem({
        name: 'item1',
        count: 2,
        stackable: true,
        max: 10
    }, 1, 1);

    const storage2 = new Storage('inventory2', 3, 5, "Körte");
    storage2.genHtml($(".Pockets"));
    storage2.addItem({
        name: 'item2',
        count: 1,
        stackable: true,
        max: 10
    }, 0, 0);

    const storage3 = new Storage('inventory2', 2, 2, "Zseb1");
    const storage4 = new Storage('inventory2', 2, 2, "Zseb2");
    storage3.genHtml($(".Pockets"));
    storage4.genHtml($(".Pockets"));

    // Store references to storage instances
    $(`#${storage.id}`).data('storage', storage);
    $(`#${storage2.id}`).data('storage', storage2);
});