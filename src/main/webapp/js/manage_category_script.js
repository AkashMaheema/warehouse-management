
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageCategory', {
                action: 'create',
                name: $(this).find('[name=name]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=name]').val(row.find('.name').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageCategory', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                name: $(this).find('[name=name]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageCategory', {
                    action: 'delete',
                    id: id
                }, function() {
                    location.reload();
                });
            }
        });
