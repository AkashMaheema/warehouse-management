// Live search reusable logic
$('#searchInput').on('keyup', function () {
    const value = $(this).val().toLowerCase();

    $('table tbody tr').each(function () {
        let matchFound = false;

        $(this).find('td').each(function () {
            if ($(this).text().toLowerCase().includes(value)) {
                matchFound = true;
                return false; // break inner loop early
            }
        });

        $(this).toggle(matchFound);
    });
});
$('#searchInput').on('keyup', function () {
    const value = $(this).val().toLowerCase();
    $('#productTable tr').filter(function () {
        $(this).toggle($(this).find('.product-name').text().toLowerCase().indexOf(value) > -1);
    });
});
