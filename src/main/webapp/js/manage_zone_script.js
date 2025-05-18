
    $('#addForm').submit(function(e) {
        e.preventDefault();
        $.post('manageZone', {
            action: 'create',
            name: this.name.value,
            capacity: this.capacity.value,
            used: this.used.value
        }, () => location.reload());
    });

    $('.editBtn').click(function() {
        const row = $(this).closest('tr');
        $('#editForm [name=id]').val(row.data('id'));
        $('#editForm [name=name]').val(row.find('.name').text());
        $('#editForm [name=capacity]').val(row.find('.capacity').text());
        $('#editForm [name=used]').val(row.find('.used').text());
        new bootstrap.Modal(document.getElementById('editModal')).show();
    });

    $('#editForm').submit(function(e) {
        e.preventDefault();
        $.post('manageZone', {
            action: 'update',
            id: this.id.value,
            name: this.name.value,
            capacity: this.capacity.value,
            used: this.used.value
        }, () => location.reload());
    });

    $('.deleteBtn').click(function() {
        if (confirm("Are you sure?")) {
            const id = $(this).closest('tr').data('id');
            $.post('manageZone', {
                action: 'delete',
                id: id
            }, () => location.reload());
        }
    });
