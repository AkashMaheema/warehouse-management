
        $('#addForm').submit(function(e) {
            e.preventDefault();
            $.post('manageWeights', {
                action: 'create',
                weightValue: $(this).find('[name=weightValue]').val()
            }, function() {
                location.reload();
            });
        });

        $('.editBtn').click(function() {
            const row = $(this).closest('tr');
            $('#editForm [name=id]').val(row.data('id'));
            $('#editForm [name=weightValue]').val(row.find('.value').text());
            new bootstrap.Modal(document.getElementById('editModal')).show();
        });

        $('#editForm').submit(function(e) {
            e.preventDefault();
            $.post('manageWeights', {
                action: 'update',
                id: $(this).find('[name=id]').val(),
                weightValue: $(this).find('[name=weightValue]').val()
            }, function() {
                location.reload();
            });
        });

        $('.deleteBtn').click(function() {
            if (confirm("Are you sure?")) {
                const id = $(this).closest('tr').data('id');
                $.post('manageWeights', {
                    action: 'delete',
                    id: id
                }, function() {
                    location.reload();
                });
            }
        });
