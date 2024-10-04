import 'flowbite'

document.addEventListener("DOMContentLoaded", function () {
    if (document.getElementById("order-create-form") === null) {
        return;
    }

    const form = document.getElementById("order-create-form");
    const itemsJsonField = document.getElementById("items-json");
    const itemQuantities = document.querySelectorAll("input[name='quantity']");
    const totalField = document.getElementById("order-total");

    const updateTotal = () => {
        let total = 0;

        itemQuantities.forEach((input) => {
            const itemId = input.getAttribute("data-item-id");
            const priceField = document.getElementById(`item-price-${itemId}`);
            const quantity = parseInt(input.value);
            const price = parseInt(priceField.textContent);

            if (!isNaN(quantity) && !isNaN(price)) {
                total += quantity * price;
            }
        });

        totalField.textContent = total;
        document.getElementById("total-field").value = total;
    };

    document.querySelectorAll("[data-input-counter-increment]").forEach(button => {
        button.addEventListener("click", function () {
            setTimeout(updateTotal, 50);  // Add a small delay to wait for Flowbite to update the input
        });
    });

    document.querySelectorAll("[data-input-counter-decrement]").forEach(button => {
        button.addEventListener("click", function () {
            setTimeout(updateTotal, 50);  // Add a small delay to wait for Flowbite to update the input
        });
    });

    form.addEventListener("submit", function (event) {
        event.preventDefault();

        const itemsArray = [];
        itemQuantities.forEach((input) => {
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

    updateTotal();
});
