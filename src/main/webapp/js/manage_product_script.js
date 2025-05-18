
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageProduct', {
                action: 'create',
                productName: $(this).find('[name=productName]').val(),
                categoryId: $(this).find('[name=categoryId]').val(),
                weightId: $(this).find('[name=weightId]').val(),
                reorderLevel: $(this).find('[name=reorderLevel]').val()
            }, function() {
                location.reload(); // Refresh the page after adding the product
            });
        });


        // Populate Edit Modal with product data
        $('#editModal').on('show.bs.modal', function (event) {
            const button = $(event.relatedTarget);
            const row = button.closest('tr');

            $('#editProductId').val(button.data('id'));
            $('#editProductName').val(row.find('td:eq(1)').text());
            $('#editCategoryId option').filter(function() {
                return $(this).text() === row.find('td:eq(2)').text();
            }).prop('selected', true);
            $('#editWeightId option').filter(function() {
                return $(this).text() === row.find('td:eq(3)').text();
            }).prop('selected', true);
            $('#editReorderLevel').val(row.find('td:eq(4)').text());
        });

        // Handle form submit
        $('#editForm').submit(function(e) {
            e.preventDefault();

            // Log the values being submitted
            console.log({
                action: 'edit',
                productId: $('#editProductId').val(),
                productName: $('#editProductName').val(),
                categoryId: $('#editCategoryId').val(),
                weightId: $('#editWeightId').val(),
                reorderLevel: $('#editReorderLevel').val()
            });

            $.post('manageProduct', {
                action: 'update',
                productId: $('#editProductId').val(),
                productName: $('#editProductName').val(),
                categoryId: $('#editCategoryId').val(),
                weightId: $('#editWeightId').val(),
                reorderLevel: $('#editReorderLevel').val()
            }, function() {
                location.reload(); // Refresh after update
            });
        });
        function deleteProduct(productId) {
                    if (confirm("Are you sure you want to delete this product?")) {
                        $.post('manageProduct', {
                            action: 'delete',
                            productId: productId
                        }, function() {
                            location.reload(); // Refresh the page after deleting the product
                        });
            }
        }
