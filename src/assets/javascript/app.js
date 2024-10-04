import 'flowbite'

document.addEventListener("DOMContentLoaded", function () {
    if (document.getElementById("order-create-form") === null) {
        return;
    }

    const form = document.getElementById("order-create-form");
    const itemsJsonField = document.getElementById("items-json");
    const itemQuantities = document.querySelectorAll("input[name='quantity']");

    form.addEventListener("submit", function (event) {
        event.preventDefault();

        const itemsArray = [];
        itemQuantities.forEach((input, index) => {
            const itemId = input.getAttribute("data-item-id");
            const quantity = parseInt(input.value);

            if (quantity > 0) {
                const itemObject = {};
                itemObject[itemId] = quantity;
                itemsArray.push(itemObject);
            }
        });

        itemsJsonField.value = JSON.stringify(itemsArray);
        form.submit();
    });
});
