<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ABC College of Engineering</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --gold: #c9a84c;
            --gold-light: #e8c97a;
            --gold-dim: rgba(201, 168, 76, 0.15);
            --dark: #0a0a0f;
            --dark-mid: #12121a;
            --cream: #f5f0e8;
            --white: #ffffff;
        }

        html, body {
            height: 100%;
            overflow: hidden;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background-color: var(--dark);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            position: relative;
        }

        /* Layered background */
        .bg-image {
            position: fixed;
            inset: 0;
            background: url('assets/college.jpg') no-repeat center center / cover;
            filter: brightness(0.25) saturate(0.6);
            transform: scale(1.05);
            z-index: 0;
            animation: slowZoom 20s ease-in-out infinite alternate;
        }

        @keyframes slowZoom {
            from { transform: scale(1.05); }
            to   { transform: scale(1.12); }
        }

        /* Noise grain overlay */
        .grain {
            position: fixed;
            inset: 0;
            z-index: 1;
            opacity: 0.04;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
            background-repeat: repeat;
            background-size: 128px;
            pointer-events: none;
        }

        /* Radial glow behind card */
        .glow {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 700px;
            height: 700px;
            background: radial-gradient(ellipse at center, rgba(201,168,76,0.12) 0%, transparent 70%);
            z-index: 2;
            pointer-events: none;
        }

        /* Main card */
        .card {
            position: relative;
            z-index: 10;
            width: min(480px, 92vw);
            padding: 56px 48px 52px;
            text-align: center;
            background: linear-gradient(160deg, rgba(255,255,255,0.05) 0%, rgba(255,255,255,0.02) 100%);
            border: 1px solid rgba(201,168,76,0.25);
            border-radius: 4px;
            backdrop-filter: blur(24px) saturate(1.4);
            box-shadow:
                0 0 0 1px rgba(201,168,76,0.08),
                0 32px 80px rgba(0,0,0,0.7),
                inset 0 1px 0 rgba(255,255,255,0.07);
            animation: fadeUp 0.9s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(28px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Decorative top rule */
        .card::before {
            content: '';
            display: block;
            width: 48px;
            height: 2px;
            background: var(--gold);
            margin: 0 auto 32px;
            opacity: 0.8;
        }

        /* Crest / emblem placeholder */
        .emblem {
            width: 64px;
            height: 64px;
            margin: 0 auto 24px;
            border: 1.5px solid rgba(201,168,76,0.5);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(201,168,76,0.08);
            animation: fadeUp 0.9s 0.1s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .emblem svg {
            width: 30px;
            height: 30px;
            opacity: 0.85;
        }

        .tag {
            font-family: 'DM Sans', sans-serif;
            font-size: 10px;
            font-weight: 500;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            color: var(--gold);
            opacity: 0.75;
            margin-bottom: 12px;
            animation: fadeUp 0.9s 0.15s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        h1 {
            font-family: 'Playfair Display', serif;
            font-weight: 900;
            font-size: clamp(22px, 5vw, 30px);
            line-height: 1.2;
            color: var(--cream);
            letter-spacing: -0.01em;
            margin-bottom: 10px;
            animation: fadeUp 0.9s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .subtitle {
            font-size: 13px;
            color: rgba(245,240,232,0.38);
            letter-spacing: 0.05em;
            margin-bottom: 44px;
            animation: fadeUp 0.9s 0.25s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        /* Divider line */
        .divider {
            width: 100%;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(201,168,76,0.3), transparent);
            margin-bottom: 44px;
            animation: fadeUp 0.9s 0.28s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        /* Nav buttons grid */
        .nav-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 14px;
            animation: fadeUp 0.9s 0.35s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        a.btn {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 22px;
            text-decoration: none;
            border-radius: 3px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 500;
            letter-spacing: 0.03em;
            transition: all 0.28s ease;
            position: relative;
            overflow: hidden;
        }

        a.btn-primary {
            background: linear-gradient(135deg, var(--gold) 0%, #a87c2e 100%);
            color: var(--dark);
            box-shadow: 0 4px 24px rgba(201,168,76,0.25);
        }

        a.btn-primary::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--gold-light), var(--gold));
            opacity: 0;
            transition: opacity 0.28s ease;
        }

        a.btn-primary:hover::before { opacity: 1; }
        a.btn-primary:hover {
            box-shadow: 0 8px 32px rgba(201,168,76,0.4);
            transform: translateY(-1px);
        }

        a.btn-secondary {
            background: rgba(201,168,76,0.06);
            color: rgba(245,240,232,0.7);
            border: 1px solid rgba(201,168,76,0.18);
        }

        a.btn-secondary:hover {
            background: rgba(201,168,76,0.12);
            border-color: rgba(201,168,76,0.4);
            color: var(--cream);
            transform: translateY(-1px);
        }

        .btn-label {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-label svg {
            width: 16px;
            height: 16px;
            opacity: 0.8;
        }

        .btn-arrow {
            position: relative;
            z-index: 1;
            font-size: 16px;
            opacity: 0.5;
            transition: transform 0.28s ease, opacity 0.28s ease;
        }

        a.btn:hover .btn-arrow {
            transform: translateX(4px);
            opacity: 1;
        }

        /* Footer note */
        .footer-note {
            margin-top: 36px;
            font-size: 11px;
            color: rgba(245,240,232,0.2);
            letter-spacing: 0.06em;
            animation: fadeUp 0.9s 0.45s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
    </style>
</head>
<body>

    <div class="bg-image"></div>
    <div class="grain"></div>
    <div class="glow"></div>

    <div class="card">

        <div class="emblem">
            <!-- Mortarboard icon -->
            <svg viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M2 10l10-6 10 6-10 6-10-6z"/>
                <path d="M6 12v5c0 1.657 2.686 3 6 3s6-1.343 6-3v-5"/>
                <line x1="22" y1="10" x2="22" y2="16"/>
            </svg>
        </div>

        <p class="tag">Management System</p>

        <h1>ABC College of Engineering</h1>
        <p class="subtitle">Academic Administration Portal</p>

        <div class="divider"></div>

        <div class="nav-grid">

            <a href="attendance.jsp" class="btn btn-primary">
                <span class="btn-label">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                        <path d="M9 16l2 2 4-4"/>
                    </svg>
                    Student Attendance
                </span>
                <span class="btn-arrow">→</span>
            </a>

            <a href="students" class="btn btn-secondary">
                <span class="btn-label">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
                    </svg>
                    Student Records
                </span>
                <span class="btn-arrow">→</span>
            </a>

            <a href="attendance-report" class="btn btn-secondary">
                <span class="btn-label">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"/>
                        <line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    Attendance Report
                </span>
                <span class="btn-arrow">→</span>
            </a>

        </div>

        <p class="footer-note">© <%= new java.util.Date().getYear() + 1900 %> ABC College &nbsp;·&nbsp; All rights reserved</p>

    </div>

</body>
</html>
