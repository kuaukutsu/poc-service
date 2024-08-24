<?php

declare(strict_types=1);

namespace kuaukutsu\poc\service\compliance\main;

use Leaf\App;

require dirname(__DIR__, 2) . '/vendor/autoload.php';

$app = new App();

$app::get('/', static function () use ($app) {
    $app->response()->json(
        [
            'message' => 'Service Compliance',
        ]
    );
});

$app::run();