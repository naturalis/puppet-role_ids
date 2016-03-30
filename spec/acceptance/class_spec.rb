if ENV['BEAKER'] == 'true'
  # running in BEAKER test environment
  require 'spec_helper_acceptance'
else
  # running in non BEAKER environment
  require 'serverspec'
  set :backend, :exec
end

describe 'role_ids class' do

  context 'default parameters' do
    if ENV['BEAKER'] == 'true'
      # Using puppet_apply as a helper
      it 'should work with no errors' do
        pp = <<-EOS
        class { 'role_ids': monitor_interface => "eth0", logstash_private_key => '-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC26nBYvVQ7b/Dt
6YHBTBuHOUpxNGEM1LAVhoT873pbF4cY1jRfKLUczywfCnz2nnBNEn7JaAKbB4bJ
sPqx89FXQf4A7dJ1YbRGEJCL5o/ohiaC1V45Hy5jGlFcn2RMgP0xyT9XLkHb/Ql1
3K31ykfzF2l2fPA8AhDCF3he4+6oxb05cz1QEFjONSGC5AEE/dCRiTOjjSQ+FEZv
C2IHoiK+vSPeQmJtcLtQX1Y3l6mo9VXsGxLBF1boZTvf2qZ8vYgp92dzOVsvoLne
EdUg2Yn1DoIaOPoIHYaCzYZB7d6jkxMFCMc0PHe/yXK1EdgWBQefdVX9I/Xo6BMU
up0NmrGdAgMBAAECggEAC2Pj5RK9GQpqdVYyF0hW+n+tzAjX9kWURXLf+yQqeVuo
tPo5vqc5R/b6p2Au0eih05rQPFh2uRKp6QtVQRmOsqFQYNxuW5Le9/H2HlAYLAGW
ilUhDeuMJu2vnVXrl/v8SEpg4FvoC/vgx+8bAhA7lL6jeZZkG0iBpKRzgW0uImI6
0lYmLvYSfRdGGQAeP+iIyu2rpBqy0ooi9QXHsyRx7B/09gpykAlk/QxLwNazSCcj
aUzw+X1GyeOS1hLxom6sEeG/n76HmYBBpyrbepCrCbfdYUG4BiwObD8EVvKS4j0U
HrrBCk8t7VW3hk94ZFg+Ap9TAEwh5a3hdgkW8mAvAQKBgQDqPlNzQqUTMezTDLSK
R0kpE/mVrxsOcPibL3XQTjFjQjnq0kLx1Evix/9hqj5EMbVrTcTfvzJngAETb5aj
b+TncZxq6Ud+AWry1L6cQvj1Cx9YOnbbMYz7edtR/Dc4adnZHYFn3idzBEmQIUqP
HYcjtRR94Rwuq0Ul23sPt1LEXQKBgQDH564HFN4qH+eAsOMLGF0aMbEUNur4TaTT
4yMa2z4e/O2LWTFFqSSH1aPXX9d5vJo2PjZw1PbLtEWAGBTbgcFS1nohpNigBGDc
9xn42xuioJv6UTrrmETajqiF0rw+Kywv8UKCdf9stL9AOyRE56Px6arTfcFCA8A2
bzlXzKTOQQKBgFPVUIp8vJWdFZQHBQpELwPbmUSf8b/+YIsxtimCApzyk8Xd0IW6
JBqa12R9yGEhpTstDxvA0upF3py1ICWII1VNzNxadvK60SrtRvan5W/VtjceXXFf
T4Sk/QBfkufGwme47ppc4KOCUk2aDJQhzj7STO4sRajSNSIyZd2fD6klAoGAZnhy
Eps1zq4QAz2pBHT2tIioVs5X3/Qc+6hAxHGCBGxub7HGugib+y0eETbFw1dUTV3S
lj/0SjMcNS8i8eovaQEcFcbkbBISfPIFVDUsk0505flhlIa3NLlP1VlSuSN0QRcQ
msNVrSlxp8EpNFDxDv5SXJrnx6kYjE6zPDhgeoECgYEA1DqJUeBAHVInXgTCs150
j5BTkGAz5OsLvawr0kXU21rP+Pc93MfTSn/cUtyqOYZ9MD8OitJHEOFm7dbE8Zln
p/YJKSmRwG8x5KxgX2GsLPix7WBq+v/RH/KhVn8/HFdFQxbNbjIxmfLG7P1OeQjV
qxWRYr56oiZYPolGupr0jZw=
-----END PRIVATE KEY-----',
  logstash_certificate => '-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAOKCLb3R5S9NMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTYwMzMwMTIxMzI1WhcNMjYwMzI4MTIxMzI1WjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAtupwWL1UO2/w7emBwUwbhzlKcTRhDNSwFYaE/O96WxeHGNY0Xyi1HM8s
Hwp89p5wTRJ+yWgCmweGybD6sfPRV0H+AO3SdWG0RhCQi+aP6IYmgtVeOR8uYxpR
XJ9kTID9Mck/Vy5B2/0Jddyt9cpH8xdpdnzwPAIQwhd4XuPuqMW9OXM9UBBYzjUh
guQBBP3QkYkzo40kPhRGbwtiB6Iivr0j3kJibXC7UF9WN5epqPVV7BsSwRdW6GU7
39qmfL2IKfdnczlbL6C53hHVINmJ9Q6CGjj6CB2Ggs2GQe3eo5MTBQjHNDx3v8ly
tRHYFgUHn3VV/SP16OgTFLqdDZqxnQIDAQABo1AwTjAdBgNVHQ4EFgQUCgcB1WJz
VeIHyu4iFgVhaShKAakwHwYDVR0jBBgwFoAUCgcB1WJzVeIHyu4iFgVhaShKAakw
DAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAXyhdLNOLaSfpzdFJCotG
N53QB27eOva6/E+xYi9QWGE1JsQjrSa4T8ZYkj/zGLlVmutnnPJ0sES6BtH8qlvi
6PQ86/XsVbQcXFTdgNcPLBRuPUTi9civYOrsv2MXsxcRusJe7l1XIVM6mSvAU0Cl
wQZtYNeGPAsibnbuGO29fNBdpEDC9cfyv/BvgRZT6EJzYx/tcrzFuJpPxR7cHSxF
eSVPegi06JMEH1yRQB8dlkiQ6c8Nxbv1ZPYbMJa/z0pgSkoalafFBAukJirfMuFq
GKkzZn3Oj4dQ08u4VKY4AHCdHhZtc38Zm2YU8Dzj6jxpEqLpKUJNjqLKFoM0slmj
rA==
-----END CERTIFICATE-----
',}
        EOS

        apply_manifest(pp, :catch_failures => true, :future_parser => true)
      end
    end

  end
end
