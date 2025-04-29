<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <title>Simple Attendance Management System</title>
    <meta content="Admin Dashboard" name="description" />
    <meta content="Themesbrand" name="author" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Tailwind CSS -->
    <link href="{{ asset(mix('css/app.css')) }}" rel="stylesheet" type="text/css" />
    
    <!-- Additional CSS -->
    @include('layouts.head')
</head>

<body class="pb-0" style="background:#2a3142;">
    @yield('content')
    @include('layouts.footer-script')
    @include('includes.flash')
    
    <!-- JavaScript -->
    <script src="{{ asset(mix('js/app.js')) }}"></script>
</body>

</html>
