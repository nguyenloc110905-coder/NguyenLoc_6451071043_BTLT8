$questions = 1..5 + 7..8

foreach ($q in $questions) {
    $dir = "lib\cau_$q"
    New-Item -Path "$dir\apps" -ItemType Directory -Force | Out-Null
    New-Item -Path "$dir\models" -ItemType Directory -Force | Out-Null
    New-Item -Path "$dir\views" -ItemType Directory -Force | Out-Null
    New-Item -Path "$dir\controllers" -ItemType Directory -Force | Out-Null
    New-Item -Path "$dir\utils" -ItemType Directory -Force | Out-Null
    New-Item -Path "$dir\widgets" -ItemType Directory -Force | Out-Null
    
    # Create an empty file in each to ensure directory is kept and structure exists
    Set-Content -Path "$dir\apps\app.dart" -Value "// App cho cau $q"
    Set-Content -Path "$dir\models\model.dart" -Value "// Model cho cau $q"
    Set-Content -Path "$dir\views\view.dart" -Value "// View cho cau $q"
    Set-Content -Path "$dir\controllers\controller.dart" -Value "// Controller cho cau $q"
    Set-Content -Path "$dir\utils\util.dart" -Value "// Utils cho cau $q"
    Set-Content -Path "$dir\widgets\widget.dart" -Value "// Widget cho cau $q"
    
    # Create screenshot directory
    $ssDir = "KetQua_HinhAnh\Cau_$q"
    New-Item -Path $ssDir -ItemType Directory -Force | Out-Null
}

Write-Output "Structure created!"
