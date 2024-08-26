<?php

declare(strict_types=1);

namespace kuaukutsu\poc\service\info\main;

use Leaf\App;

require dirname(__DIR__, 2) . '/vendor/autoload.php';

$app = new App();
$app::set404(static function () use ($app)  {
    $app->response()->json(
        [
            'message' => '404 Not Found',
        ],
        404
    );
});

$app::get('/', static function () use ($app) {
    $app->response()->json(
        [
            'message' => 'Service Info',
        ]
    );
});

$app::get('/info', static function () use ($app) {
    $app->response()->json(
        [
            'message' => 'Version: ' . PHP_VERSION,
        ]
    );
});

$app::run();
