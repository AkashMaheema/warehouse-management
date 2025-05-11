        function addRow() {
            const table = document.getElementById("stockTableBody");
                const firstRow = table.rows[0];
                const newRow = firstRow.cloneNode(true);

                // Clear input values in the cloned row
                newRow.querySelectorAll("input, select").forEach(el => el.value = "");

                table.appendChild(newRow);
        }

        function removeRow(btn) {
            const row = btn.parentNode.parentNode;
            row.remove();
        }

        // When product selection changes, store the product ID
        $(document).on('change', '.product-select', function() {
            var row = $(this).closest('tr');
            row.find('.zone-id, .zone-name, .rack-id, .rack-name').val('');
        });

        // Zone selection button
        $(document).on('click', '.btn-select-zone', function() {
            var row = $(this).closest('tr');
            var productId = row.find('.product-select').val();

            if (!productId) {
                alert('Please select a product first');
                return;
            }

            // AJAX call to fetch zones
            $.ajax({
                url: 'ZoneRackServlet',
                type: 'GET',
                data: {
                    type: 'zone',
                    productId: productId
                },
                success: function(response) {
                    $('#zoneTableBody').html(response);
                    $('#zoneModal').data('row', row).modal('show');
                },
                error: function() {
                    alert('Error loading zones');
                }
            });
        });

        // Rack selection button
        $(document).on('click', '.btn-select-rack', function() {
            var row = $(this).closest('tr');
            var zoneId = row.find('.zone-id').val();
            var productId = row.find('.product-select').val();

            if (!zoneId) {
                alert('Please select a zone first');
                return;
            }
            if (!productId) {
                alert('Please select a product first');
                return;
            }

            // AJAX call to fetch racks
            $.ajax({
                url: 'ZoneRackServlet',
                type: 'GET',
                data: {
                    type: 'rack',
                    productId: productId,
                    zoneId: zoneId
                },
                success: function(response) {
                    $('#rackTableBody').html(response);
                    $('#rackModal').data('row', row).modal('show');
                },
                error: function() {
                    alert('Error loading racks');
                }
            });
        });

        // Zone selection from modal
        $(document).on('click', '.select-zone', function() {
            var zoneId = $(this).data('id');
            var zoneName = $(this).data('name');
            var row = $('#zoneModal').data('row');

            row.find('.zone-id').val(zoneId);
            row.find('.zone-name').val(zoneName);

            // Clear rack selection when zone changes
            row.find('.rack-id, .rack-name').val('');

            $('#zoneModal').modal('hide');
        });

        // Rack selection from modal
        $(document).on('click', '.select-rack', function() {
            var rackId = $(this).data('id');
            var rackName = $(this).data('name');
            var row = $('#rackModal').data('row');

            row.find('.rack-id').val(rackId);
            row.find('.rack-name').val(rackName);

            $('#rackModal').modal('hide');
        });
        $(document).ready(function () {
            // Product form submission
            $('#addFormProduct').submit(function (e) {
                e.preventDefault();

                $.ajax({
                    url: 'manageProduct',
                    method: 'POST',
                    data: $(this).serialize() + '&action=create',
                    dataType: 'json', // Force JSON parsing
                    success: function (newProduct) {
                        console.log("Returned Product JSON:", newProduct);
                        $('.product-select').each(function () {
                            $(this).append(
                                $('<option>', {
                                    value: newProduct.prodasasuctId,
                                    text: newProduct.as
                                })
                            );
                        });
                        $('#addFormProduct')[0].reset();
                        $('#addModalProduct').modal('hide');
                    },
                    error: function (xhr) {
                                            console.error("AJAX error:", xhr.responseText);
                                            alert("Failed to add supplier.");
                    }
                });
            });

            // Supplier form submission
            $('#addFormSupplier').submit(function (e) {
                e.preventDefault();

                $.ajax({
                    url: 'manageSupplier',
                    method: 'POST',
                    data: $(this).serialize() + '&action=create',
                    dataType: 'json',
                    success: function (newSupplier) {
                        console.log("Returned Supplier JSON:", newSupplier); // Check the response in the browser console

                        // Find all the supplier select elements and add the new supplier option dynamically
                        $('.supplier-select').each(function () {
                            $(this).append(
                                $('<option>', {
                                    value: newSupplier.supplierId,
                                    text: newSupplier.name
                                })
                            );
                        });

                        // Reset the form and hide the modal
                        $('#addFormSupplier')[0].reset();
                        $('#addModalSupplier').modal('hide');

                    },
                    error: function (xhr) {
                        console.error("AJAX error:", xhr.responseText);
                        alert("Failed to add supplier.");
                    }
                });
            });
        });

    function addRow() {
        var newRow = $('#stockTableBody tr:first').clone();
        newRow.find('input, select').val('');
        $('#stockTableBody').append(newRow);
    }