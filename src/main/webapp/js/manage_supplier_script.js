
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageSupplier', {
                action: 'create',
                name: $(this).find('[name=name]').val(),
                contactPerson: $(this).find('[name=contactPerson]').val(),
                phone: $(this).find('[name=phone]').val(),
                email: $(this).find('[name=email]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=name]').val(row.find('.name').text());
            $('#editForm [name=contactPerson]').val(row.find('.contact').text());
            $('#editForm [name=phone]').val(row.find('.phone').text());
            $('#editForm [name=email]').val(row.find('.email').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageSupplier', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                name: $(this).find('[name=name]').val(),
                contactPerson: $(this).find('[name=contactPerson]').val(),
                phone: $(this).find('[name=phone]').val(),
                email: $(this).find('[name=email]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageSupplier', {
                    action: 'delete',
                    id: id
                }, function() {
                    location.reload();
                });
            }
        });
