<?php

declare(strict_types=1);

namespace kuaukutsu\poc\service\compliance\main;

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
            'message' => 'Service Compliance',
        ]
    );
});

$app::get('/protected', static function () use ($app) {
    $request = $app->request();
    $app->response()->json(
        [
            'message' => 'Authorization',
            'headers' => $request::headers(),
            'user' => $request::headers('X-User')
        ]
    );
});

$app::run();
