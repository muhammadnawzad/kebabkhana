import 'flowbite'

document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('order-form');
    const incrementButtons = document.querySelectorAll('[data-action="increment"]');
    const decrementButtons = document.querySelectorAll('[data-action="decrement"]');

    incrementButtons.forEach(button => button.addEventListener('click', incrementQuantity));
    decrementButtons.forEach(button => button.addEventListener('click', decrementQuantity));

    form.addEventListener('submit', function (event) {
        event.preventDefault();

        const formData = new FormData(form);
        const items = [];

        const itemIds = document.querySelectorAll('input[name="id"]');
        const itemQuantities = document.querySelectorAll('input[name="quantity"]');
        const itemTotals = document.querySelectorAll('input[name="total"]');

        for (let i = 0; i < itemIds.length; i++) {
            items.push({
                id: itemIds[i].value,
                quantity: itemQuantities[i].value,
                total: itemTotals[i].value
            });
        }

        const data = {
            items: items,
            total: document.getElementById('total-field').value
        };

        // Get CSRF token from the hidden input
        const csrfToken = document.getElementById('csrftoken').value;

        // Send the data using Fetch
        fetch(form.action, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': csrfToken // Send CSRF token as a header
            },
            body: JSON.stringify(data)
        })
            .then(response => response.json())
            .then(result => {
                window.location.href = '/kebab';
            })
            .catch(error => {
                window.location.href = '/kebab';
            });
    });

    function incrementQuantity(event) {
        const itemId = event.target.closest('button').getAttribute('data-item-id');
        const inputField = document.getElementById(`counter-input-${itemId}`);
        inputField.value = parseInt(inputField.value) + 1;
        updateTotals(itemId);
    }

    function decrementQuantity(event) {
        const itemId = event.target.closest('button').getAttribute('data-item-id');
        const inputField = document.getElementById(`counter-input-${itemId}`);
        if (parseInt(inputField.value) > 0) {
            inputField.value = parseInt(inputField.value) - 1;
        }
        updateTotals(itemId);
    }

    function updateTotals(itemId) {
        const quantity = parseInt(document.getElementById(`counter-input-${itemId}`).value);
        const price = parseFloat(document.getElementById(`item-price-${itemId}`).textContent);
        const totalField = document.getElementById(`item-total-${itemId}`);
        const itemTotal = quantity * price;

        totalField.value = itemTotal;

        // Update order total
        let orderTotal = 0;
        document.querySelectorAll('[id^="item-total-"]').forEach(item => {
            orderTotal += parseFloat(item.value);
        });

        document.getElementById('order-total').textContent = orderTotal;
        document.getElementById('total-field').value = orderTotal;
    }
});
